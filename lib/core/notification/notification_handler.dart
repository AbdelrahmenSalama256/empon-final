import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../core/common/logs.dart';
import 'local_notification_handler.dart';

class NotificationHandler {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken = '';
  static Future init() async {
    //! Request for permission
    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    //! Get the token
    fcmToken = await firebaseMessaging.getToken();
    Print.success('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    //! Handle foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService.showBasicNotification(message);
      Print.success('Notification onMessage: ${message.notification?.title}');
    });
  }

  static Future<String?> getToken() async {
    String? token = await firebaseMessaging.getToken();
    fcmToken = token;
    log('FCM Token: $token');
    return token;
  }

  //! Handle background message
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    LocalNotificationService.showBasicNotification(message);

    Print.success('Notification: ${message.notification?.title}');
  }
}
