import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:madares_app_teacher/core/repositories/settingsRepository.dart';
import 'package:madares_app_teacher/features/chat/data/models/chatNotificationData.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatNotificationsUtils {
  static int? currentChattingUserId;

  static late StreamController<ChatNotificationData> notificationStreamController;

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// Initializes the notification system
  static initialize() {
    print("ChatNotificationsUtils: initialize called");
    SettingsRepository().setBackgroundChatNotificationData(data: []);
    notificationStreamController = StreamController.broadcast();
  }

  /// Disposes the notification stream
  static dispose() {
    print("ChatNotificationsUtils: dispose called");
    notificationStreamController.close();
  }

  /// Handles foreground chat notifications
  static addChatStreamAndShowNotification({required RemoteMessage message}) {
    print("ChatNotificationsUtils: addChatStreamAndShowNotification called");
    final chatNotification =
    ChatNotificationData.fromRemoteMessage(remoteMessage: message);
    notificationStreamController.add(chatNotification);

    if (currentChattingUserId != chatNotification.fromUser.userId &&
        Platform.isAndroid) {
      createChatNotification(chatData: chatNotification, message: message);
    }
  }

  /// Adds a chat notification to the stream
  static addChatStreamValue({required ChatNotificationData chatData}) {
    print("ChatNotificationsUtils: addChatStreamValue called");
    notificationStreamController.add(chatData);
  }

  /// Creates and displays a local notification for chat messages
  static Future<void> createChatNotification({
    required ChatNotificationData chatData,
    required RemoteMessage message,
  }) async {
    print("ChatNotificationsUtils: createChatNotification called");
    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? image = message.data['image'];

    AndroidNotificationDetails androidDetails;

    if (image == null) {
      androidDetails = AndroidNotificationDetails(
        'chat_channel', // Channel ID
        'Chat Notifications', // Channel Name
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        largeIcon: chatData.fromUser.profileUrl != null
            ? FilePathAndroidBitmap(chatData.fromUser.profileUrl!)
            : null,
      );
    } else {
      final bigPictureStyle = BigPictureStyleInformation(
        FilePathAndroidBitmap(image),
        contentTitle: title,
        summaryText: body,
      );

      androidDetails = AndroidNotificationDetails(
        'chat_channel',
        'Chat Notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        styleInformation: bigPictureStyle,
      );
    }

    NotificationDetails details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(5000), // Unique notification ID
      title.isNotEmpty ? title : "New Messages", // Fallback title
      body,
      details,
      payload: message.data['sender_info'],
    );
  }
}
