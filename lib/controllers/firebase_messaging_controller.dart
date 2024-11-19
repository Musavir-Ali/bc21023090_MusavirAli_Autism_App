import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseMessagingController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() {
    super.onInit();
    setupLocalNotifications();
    setupFirebaseMessagingListeners();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Handle notification that launched the app
        showLocalNotification(message.notification?.title, message.notification?.body);
      }
    });
  }

  void setupLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        print("Notification clicked: ${response.payload}");
      },
    );
  }

  Future<void> showLocalNotification(String? title, String? body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '911_channel', // Channel ID
      '911 Events', // Channel Name
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }

  void setupFirebaseMessagingListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message.notification?.title, message.notification?.body);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened: ${message.notification?.title}");
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background message received: ${message.notification?.title}");
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
    '911_channel',
    '911 Events',
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}
