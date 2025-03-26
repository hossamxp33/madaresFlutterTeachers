import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:madares_app_teacher/app/routes.dart';
import 'package:madares_app_teacher/core/repositories/settingsRepository.dart';
import 'package:madares_app_teacher/core/utils/constants.dart';
import 'package:madares_app_teacher/core/utils/notificationUtils/chatNotificationsUtils.dart';
import 'package:madares_app_teacher/core/utils/uiUtils.dart';
import 'package:madares_app_teacher/features/chat/data/models/chatNotificationData.dart';
import 'package:madares_app_teacher/features/chat/data/models/chatUser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class NotificationUtility {
  static const String chatNotificationType = "chat";
  static final List<String> notificationTypesToNotIncrementCount = [chatNotificationType];

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamSubscription<RemoteMessage>? openAppStreamSubscription;
  static StreamSubscription<RemoteMessage>? onMessageOpenAppStreamSubscription;

  static Future<void> init() async {
    await Firebase.initializeApp();
    ChatNotificationsUtils.initialize();
    await _requestPermissions();
    await _initializeLocalNotifications();
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined ||
        settings.authorizationStatus == AuthorizationStatus.denied) {
      await FirebaseMessaging.instance.requestPermission();
    }
  }

  static Future<void> setUpNotificationService(BuildContext context) async {
    ChatNotificationsUtils.initialize();
    await _requestPermissions();
    if (context.mounted) initNotificationListener(context);
    await _initializeLocalNotifications();
  }

  static Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload ?? "");
      },
    );
  }

  static void initNotificationListener(BuildContext context) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    openAppStreamSubscription = FirebaseMessaging.onMessage.listen(foregroundMessageListener);
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    onMessageOpenAppStreamSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen((msg) => onMessageOpenedAppListener(msg, context));
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    if (!notificationTypesToNotIncrementCount.contains(message.data["type"])) {
      int count = await SettingsRepository().getNotificationCount();
      await SettingsRepository().setNotificationCount(count + 1);
    }
    
    if (message.data["type"] == chatNotificationType) {
      final chatData = ChatNotificationData.fromRemoteMessage(remoteMessage: message);
      final List<ChatNotificationData> oldList = await SettingsRepository().getBackgroundChatNotificationData();
      oldList.add(chatData);
      SettingsRepository().setBackgroundChatNotificationData(data: oldList);
      if (Platform.isAndroid) ChatNotificationsUtils.createChatNotification(chatData: chatData, message: message);
    } else {
      if (Platform.isAndroid) await createLocalNotification(message: message);
    }
  }

  static Future<void> foregroundMessageListener(RemoteMessage message) async {
    if (!notificationTypesToNotIncrementCount.contains(message.data["type"])) {
      int count = await SettingsRepository().getNotificationCount();
      await SettingsRepository().setNotificationCount(count + 1);
    }
    
    if (message.data["type"] == chatNotificationType) {
      ChatNotificationsUtils.addChatStreamAndShowNotification(message: message);
    } else {
      if (Platform.isAndroid) await createLocalNotification(message: message);
    }
  }

  static void onMessageOpenedAppListener(RemoteMessage message, BuildContext context) {
    _handleNotificationTap(message.data['type'] ?? "");
  }

  static void _handleNotificationTap(String notificationType) {
    if (notificationType == chatNotificationType) {
      if (Routes.currentRoute == Routes.chatMessages) {
        UiUtils.rootNavigatorKey.currentState?.pop();
      }
      UiUtils.rootNavigatorKey.currentState?.pushNamed(
        Routes.chatMessages,
        arguments: {
          "chatUser": ChatUser.fromJsonAPI(jsonDecode(notificationType))
        },
      );
    }
  }

  static Future<void> createLocalNotification({required RemoteMessage message}) async {
    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? imageUrl = message.data['image'];

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final ByteArrayAndroidBitmap bigPicture = await _downloadImage(imageUrl);
        final BigPictureStyleInformation bigPictureStyle = BigPictureStyleInformation(
          bigPicture,
          contentTitle: title,
          summaryText: body,
        );

        androidDetails = AndroidNotificationDetails(
          'default_channel',
          'General Notifications',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          styleInformation: bigPictureStyle,
        );
      } catch (e) {
        print("Failed to load image for notification: $e");
      }
    }

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      Random().nextInt(5000),
      title,
      body,
      details,
      payload: message.data['type'],
    );
  }

  static Future<ByteArrayAndroidBitmap> _downloadImage(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ByteArrayAndroidBitmap(response.bodyBytes);
    } else {
      throw Exception("Failed to download image: ${response.statusCode}");
    }
  }

  static void removeListener() {
    try {
      openAppStreamSubscription?.cancel();
      onMessageOpenAppStreamSubscription?.cancel();
      SettingsRepository().setNotificationCount(0);
      ChatNotificationsUtils.dispose();
    } catch (_) {}
  }
}
