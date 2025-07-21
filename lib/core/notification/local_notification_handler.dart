import 'dart:async';
import 'dart:convert';

import 'package:embone/core/app/embone.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/client/notifications/view/cubit/notifications_cubit.dart';
import '../../features/client/order/view/order_details_screen.dart';
import '../../features/client/product_Details/view/product_details_screen.dart';
import '../../features/client/product_Details/view/service_detailes_secreen.dart';
import '../common/logs.dart';
import '../component/custom_toast.dart';
import '../constants/custom_popup.dart';
import '../cubit/global_cubit.dart';

// Background handler must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await LocalNotificationService.init();
  LocalNotificationService.showBasicNotification(message);
}

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final StreamController<NotificationResponse> streamController =
      StreamController<NotificationResponse>.broadcast();

  static Future<void> init() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Print.info('Foreground message received: ${message.data}');
      showBasicNotification(message);
      handleNotificationUpdate(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Print.info('Message opened app: ${message.data}');
      _handleNotificationTap(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await FirebaseMessaging.instance.getToken();
    Print.info('FCM Token: $token');

    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );

    streamController.stream.listen((response) {
      onTap(response);
    });
  }

  static void onTap(NotificationResponse notificationResponse) {
    Map<String, dynamic>? map =
        jsonDecode(notificationResponse.payload ?? "{}");
    if (map != null && navigatorKey.currentState != null) {
      navigateBasedOnPayload(map);
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (navigatorKey.currentState != null &&
            map != null &&
            map.isNotEmpty) {
          navigateBasedOnPayload(map);
        }
      });
    }
  }

  static void showBasicNotification(RemoteMessage message) async {
    const AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@drawable/ic_notification",
    );
    const NotificationDetails details = NotificationDetails(android: android);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new notification',
      details,
      payload: jsonEncode(message.data),
    );
  }

  static void _handleNotificationTap(RemoteMessage message) {
    Map<String, dynamic> map = message.data;
    if (navigatorKey.currentState != null && map.isNotEmpty) {
      navigateBasedOnPayload(map);
    }
  }

  static void handleNotificationUpdate(RemoteMessage message) {
    Print.info('Processing notification update: ${message.data}');
    if (navigatorKey.currentContext != null) {
      final notificationsCubit = BlocProvider.of<NotificationsCubit>(
        navigatorKey.currentContext!,
        listen: false,
      );
      if (notificationsCubit != null) {
        notificationsCubit.handleNotificationUpdate(message.data.isNotEmpty
            ? message.data
            : {'type': 'default', 'account_id': 0, 'verified': 0});
      } else {
        Print.error('Notification Data not found in current context');
      }
    } else {
      Print.error('No current context available for notification update');
    }
  }

  static void navigateBasedOnPayload(Map<String, dynamic> map) {
    final String? type = map["type"];
    final int? notifiableId = map["notifiable_id"] as int?;

    if (type == null || notifiableId == null) return;

    if (navigatorKey.currentContext == null) return;

    switch (type) {
      case 'App\\\\Models\\\\Account\\\\True':
        final globalCubit = navigatorKey.currentContext!.read<GlobalCubit>();
        if (globalCubit.businessId != notifiableId) {
          globalCubit.setBusinessId(notifiableId);
          globalCubit.setUserType(UserType.business);
          globalCubit.changeBottomNavIndex(0);
        }
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      case 'App\\\\Models\\\\Account\\\\False':
        final globalCubit = navigatorKey.currentContext!.read<GlobalCubit>();
        globalCubit.changeBottomNavIndex(3);
        CustomPopup.show(
          context: navigatorKey.currentContext!,
          title: 'inactive_account_title'.tr(navigatorKey.currentContext!),
          message: 'inactive_account_message'.tr(navigatorKey.currentContext!),
          type: PopupType.alert,
          primaryButtonText: 'ok'.tr(navigatorKey.currentContext!),
          onPrimaryButtonPressed: () {
            Navigator.of(navigatorKey.currentContext!, rootNavigator: true)
                .pop();
            globalCubit.setUserType(UserType.client);
          },
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      case 'App\\\\Models\\\\Product':
        navigateTo(
          navigatorKey.currentContext!,
          BlocProvider(
            create: (context) => SearchCubit(sl<SearchRepo>()),
            child: ProductDetailPage(productId: notifiableId),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      case 'account_verification':
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      case 'App\\\\Models\\\\Service':
        navigateTo(
            navigatorKey.currentContext!,
            BlocProvider(
              create: (context) => SearchCubit(sl<SearchRepo>()),
              child: ServiceDetailPage(
                isVendor: false,
                serviceId: notifiableId,
              ),
            ));
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      case 'App\\\\Models\\\\Product\\\\order':
        navigateTo(
          navigatorKey.currentContext!,
          BlocProvider(
            create: (context) =>
                OrdersCubit(sl<OrderRepo>())..fetchOrderDetails(notifiableId),
            child: OrderDetailsScreen(orderId: notifiableId),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
      default:
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
    }
  }
}
