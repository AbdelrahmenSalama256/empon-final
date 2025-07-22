import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:embone/core/app/embone.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/notifications/view/notification_screen.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/client/chat/data/repo/chat_repo.dart';
import '../../features/client/chat/view/chat_conversation_screen.dart';
import '../../features/client/chat/view/cubit/chat_cubit.dart';
import '../../features/client/order/view/order_details_screen.dart';
import '../../features/client/product_Details/view/product_details_screen.dart';
import '../../features/client/product_Details/view/service_detailes_secreen.dart';
import '../common/logs.dart';
import '../component/custom_toast.dart';
import '../constants/custom_popup.dart';
import '../cubit/global_cubit.dart';
import 'notification_handler.dart';

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
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: DarwinInitializationSettings(),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _onNotificationTap(response);
      },
    );

    streamController.stream.listen((response) {
      _onNotificationTap(response);
    });
  }

  static void _onNotificationTap(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        NotificationHandler.handleNavigation(data);
      }
    } catch (e, stack) {
      log('Error in _onNotificationTap: $e');
      log('Stack trace: $stack');
    }
  }

  static Future<void> showBasicNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      icon: "@drawable/ic_notification",
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode, // Unique ID for each notification
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? 'You have a new notification',
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static void navigateBasedOnPayload(Map<String, dynamic> map) async {
    try {
      final String? type = map["type"];
      final dynamic notifiableIdDynamic = map["notifiable_id"];
      final dynamic fromUserDynamic = map["from_user"];

      final int? notifiableId = notifiableIdDynamic is String
          ? int.tryParse(notifiableIdDynamic)
          : notifiableIdDynamic as int?;

      final int? fromUser = fromUserDynamic is String
          ? int.tryParse(fromUserDynamic)
          : fromUserDynamic as int?;

      if (type == null || (notifiableId == null && fromUser == null)) {
        log('Invalid notification payload: $map');
        return;
      }

      if (navigatorKey.currentContext == null) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (navigatorKey.currentContext == null) return;
      }

      navigatorKey.currentContext!.read<GlobalCubit>();
      if (AppConstants.token == null) return;

      // Rest of your existing navigation logic...
      // Make sure all navigations are awaited
      await _handleNavigation(type, notifiableId, fromUser, map);
    } catch (e, stack) {
      log('Error in navigateBasedOnPayload: $e');
      log('Stack trace: $stack');
    }
  }

  static Future<void> _handleNavigation(String type, int? notifiableId,
      int? fromUser, Map<String, dynamic> map) async {
    switch (type) {
      case 'App\\\\Models\\\\Account\\\\True':
        if (navigatorKey.currentContext!.read<GlobalCubit>().businessId !=
            notifiableId) {
          navigatorKey.currentContext!
              .read<GlobalCubit>()
              .setBusinessId(notifiableId);
          navigatorKey.currentContext!
              .read<GlobalCubit>()
              .setUserType(UserType.business);
          navigatorKey.currentContext!
              .read<GlobalCubit>()
              .changeBottomNavIndex(0);
        }
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;

      case 'App\\\\Models\\\\Account\\\\False':
        navigatorKey.currentContext!
            .read<GlobalCubit>()
            .changeBottomNavIndex(3);
        CustomPopup.show(
          context: navigatorKey.currentContext!,
          title: 'inactive_account_title'.tr(navigatorKey.currentContext!),
          message: 'inactive_account_message'.tr(navigatorKey.currentContext!),
          type: PopupType.alert,
          primaryButtonText: 'ok'.tr(navigatorKey.currentContext!),
          onPrimaryButtonPressed: () {
            Navigator.of(navigatorKey.currentContext!, rootNavigator: true)
                .pop();
            navigatorKey.currentContext!
                .read<GlobalCubit>()
                .setUserType(UserType.client);
          },
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;

      case 'App\\\\Models\\\\Product':
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SearchCubit(sl<SearchRepo>()),
              child: ProductDetailPage(productId: notifiableId ?? 0),
            ),
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
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => SearchCubit(sl<SearchRepo>()),
              child: ServiceDetailPage(
                isVendor: false,
                serviceId: notifiableId ?? 0,
              ),
            ),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;

      case 'App\\\\Models\\\\Product\\\\order':
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => OrdersCubit(sl<OrderRepo>())
                ..fetchOrderDetails(notifiableId ?? 0),
              child: OrderDetailsScreen(orderId: notifiableId ?? 0),
            ),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;

      case 'chat':
        if (fromUser == null) {
          Print.error('from_user is null or invalid in payload: $map');
          return;
        }

        // Safely get the current user ID
        final currentUserId =
            navigatorKey.currentContext!.read<GlobalCubit>().userId;
        if (currentUserId == null) {
          Print.error('Current user ID is null');
          return;
        }

        final String name = map['name'] ?? 'Unknown';
        final int isOnline = map['is_online'] != null
            ? (map['is_online'] is String
                ? int.tryParse(map['is_online']) ?? 0
                : map['is_online'] as int)
            : 0;

        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => ChatCubit(
                sl<ChatRepo>(),
                fromUser,
                int.parse(currentUserId),
              )..fetchMessages(fromUser),
              child: ChatConversationScreen(
                receiverId: fromUser,
                name: name,
                online: isOnline == 1
                    ? 'online'.tr(context)
                    : 'offline'.tr(context),
                image: map['image'],
              ),
            ),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: "new_massage_from".tr(navigatorKey.currentContext!) + name,
            state: ToastStates.success);
        break;

      default:
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const NotificationsPage(),
          ),
        );
        showToast(navigatorKey.currentContext!,
            message: map["body"] ?? "Notification", state: ToastStates.success);
        break;
    }
  }
}
