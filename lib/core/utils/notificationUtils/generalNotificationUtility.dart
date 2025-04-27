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
  static String customNotificationType = "custom";
  static String noticeboardNotificationType = "noticeboard";
  static String classNoticeboardNotificationType = "class";
  static String classSectionNoticeboardNotificationType = "class_section";
  static String assignmentlNotificationType = "assignment";
  static String assignmentSubmissionNotificationType = "assignment_submission";
  static String onlineFeePaymentNotificationType = "Online";
  static String attendenceNotificationType = "attendance";

  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static StreamSubscription<RemoteMessage>? openAppStreamSubscription;
  static StreamSubscription<RemoteMessage>? onMessageOpenAppStreamSubscription;
  static Set<String> processedMessageIds = Set();  // Store processed message IDs

  static Future<void> init() async {
    print("[NotificationUtility] init called");
    await Firebase.initializeApp();
    ChatNotificationsUtils.initialize();
    await _requestPermissions();
    await _initializeLocalNotifications();
  }

  static Future<void> _requestPermissions() async {
    print("[NotificationUtility] _requestPermissions called");
    NotificationSettings settings = await FirebaseMessaging.instance.getNotificationSettings();
    if (settings.authorizationStatus == AuthorizationStatus.notDetermined ||
        settings.authorizationStatus == AuthorizationStatus.denied) {
      print("[NotificationUtility] requesting notification permissions");
      await FirebaseMessaging.instance.requestPermission();
    }
  }

  static Future<void> setUpNotificationService(BuildContext context) async {
    print("[NotificationUtility] setUpNotificationService called");
    ChatNotificationsUtils.initialize();
    await _requestPermissions();
    if (context.mounted) {
      print("[NotificationUtility] context is mounted, initializing listener");
      initNotificationListener(context);
    }
    await _initializeLocalNotifications();
  }

  static Future<void> _initializeLocalNotifications() async {
    print("[NotificationUtility] _initializeLocalNotifications called");
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings settings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("[NotificationUtility] onDidReceiveNotificationResponse triggered");
        _handleNotificationTap(response.payload ?? "", {});
      },
    );
  }

  static void initNotificationListener(BuildContext context) {
    print("[NotificationUtility] initNotificationListener called");

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      foregroundMessageListener(message); // Handle when app is in the foreground
    });

    // Listen for when a user taps on the notification and the app opens
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedAppListener(message, context); // Handle notification tap action
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    print("[NotificationUtility] onBackgroundMessage called");
    await Firebase.initializeApp();

    // Ensure we only handle one notification type, e.g., chat or general notification
    if (message.data["type"] == chatNotificationType) {
      print("[NotificationUtility] onBackgroundMessage: chat notification received");
      await _handleChatNotification(message);
    } else {
      print("[NotificationUtility] onBackgroundMessage: general notification received");
      await _handleGeneralNotification(message);
    }
  }

  static Future<void> foregroundMessageListener(RemoteMessage message) async {
    print("[NotificationUtility] foregroundMessageListener called");

    // Skip the notification if the message has already been processed
    String messageId = message.messageId ?? Random().nextInt(100000).toString(); // Generate unique messageId
    if (processedMessageIds.contains(messageId)) return;

    processedMessageIds.add(messageId); // Mark the message as processed

    // Handle the foreground messages, ensuring only one notification is shown
    if (message.data["type"] == chatNotificationType) {
      print("[NotificationUtility] foregroundMessageListener: chat notification received");
      await _handleChatNotification(message);
    } else {
      print("[NotificationUtility] foregroundMessageListener: general notification received");
      await _handleGeneralNotification(message);
    }

    // Reset the flag after processing the notification
    await Future.delayed(Duration(seconds: 1));
  }

  static void onMessageOpenedAppListener(RemoteMessage message, BuildContext context) {
    print("[NotificationUtility] onMessageOpenedAppListener called");
    _handleNotificationTap(message.data['type'] ?? "", message.data);
  }

  static void _handleNotificationTap(String notificationType, Map<String, dynamic> data) {
    print("[NotificationUtility] _handleNotificationTap called with type: $notificationType");

    if (notificationType == customNotificationType) {
      UiUtils.rootNavigatorKey.currentState?.pushNamed(Routes.notifications);
    } else if (notificationType == assignmentSubmissionNotificationType) {
      UiUtils.rootNavigatorKey.currentState?.pushNamed(Routes.assignments);
    } else if (notificationType == chatNotificationType) {
      if (Routes.currentRoute == Routes.chatMessages) {
        UiUtils.rootNavigatorKey.currentState?.pop();
      }
      UiUtils.rootNavigatorKey.currentState?.pushNamed(
        Routes.chatMessages,
        arguments: {
          "chatUser": ChatUser.fromJsonAPI(jsonDecode(data['sender_info']))
        },
      );
    }
  }

  static Future<void> _handleChatNotification(RemoteMessage message) async {
    final chatData = ChatNotificationData.fromRemoteMessage(remoteMessage: message);
    final List<ChatNotificationData> oldList = await SettingsRepository().getBackgroundChatNotificationData();
    oldList.add(chatData);
    SettingsRepository().setBackgroundChatNotificationData(data: oldList);
    if (Platform.isAndroid) {
      print("[NotificationUtility] onBackgroundMessage: creating Android chat notification");
      // ChatNotificationsUtils.createChatNotification(chatData: chatData, message: message);
    }
  }

  static Future<void> _handleGeneralNotification(RemoteMessage message) async {
    if (Platform.isAndroid) {
      await createLocalNotification(message: message);
    }
  }

  static Future<void> createLocalNotification({required RemoteMessage message}) async {
    print("[NotificationUtility] createLocalNotification called");
    String title = message.notification?.title ?? message.data["title"] ?? "";
    String body = message.notification?.body ?? message.data["body"] ?? "";
    String? imageUrl = message.data['image'];

    print("[NotificationUtility] Notification title: $title, body: $body");

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
        print("[NotificationUtility] Failed to load image for notification: $e");
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
    print("[NotificationUtility] Local notification displayed");
  }

  static Future<ByteArrayAndroidBitmap> _downloadImage(String url) async {
    print("[NotificationUtility] _downloadImage called with URL: $url");
    final http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      print("[NotificationUtility] Image downloaded successfully");
      return ByteArrayAndroidBitmap(response.bodyBytes);
    } else {
      print("[NotificationUtility] Failed to download image. Status code: ${response.statusCode}");
      throw Exception("Failed to download image: ${response.statusCode}");
    }
  }

  static void removeListener() {
    print("[NotificationUtility] removeListener called");
    try {
      openAppStreamSubscription?.cancel();
      onMessageOpenAppStreamSubscription?.cancel();
      SettingsRepository().setNotificationCount(0);
      ChatNotificationsUtils.dispose();
      print("[NotificationUtility] Listeners and ChatNotificationUtils disposed");
    } catch (e) {
      print("[NotificationUtility] Error in removeListener: $e");
    }
  }
}
