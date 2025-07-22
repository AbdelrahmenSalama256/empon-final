import 'dart:developer';
import 'dart:io';

import 'package:embone/core/app/embone.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'local_notification_handler.dart';

class NotificationHandler {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String? fcmToken = '';
  static bool _isInitialized = false;

  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    final cubit = sl<GlobalCubit>();
    if (!cubit.isNotificationsDisabled && message.notification != null) {
      LocalNotificationService.showBasicNotification(message);
    }
    if (!kReleaseMode) {
      log('Background Notification: ${message.notification?.title}');
    }
  }

  static Future<void> handleNavigation(Map<String, dynamic> data) async {
    try {
      if (navigatorKey.currentState != null && data.isNotEmpty) {
        LocalNotificationService.navigateBasedOnPayload(data);
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
        if (navigatorKey.currentState != null && data.isNotEmpty) {
          LocalNotificationService.navigateBasedOnPayload(data);
        }
      }
    } catch (e, stack) {
      log('Error in handleNavigation: $e');
      log('Stack trace: $stack');
    }
  }

  static Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (Platform.isIOS) {
      await firebaseMessaging.getAPNSToken();
    }
    fcmToken = await firebaseMessaging.getToken();
    log('FCM Token: $fcmToken');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final cubit = sl<GlobalCubit>();
      if (!cubit.isNotificationsDisabled) {
        LocalNotificationService.showBasicNotification(message);
        if (!kReleaseMode) {
          log('Foreground Notification: ${message.notification?.title}');
          log('Notification Data: ${message.data}');
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNavigation(message.data);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNavigation(initialMessage.data);
      });
    }

    await LocalNotificationService.init();
  }
}
