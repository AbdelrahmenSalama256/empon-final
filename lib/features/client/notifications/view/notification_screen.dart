// ignore_for_file: camel_case_types

import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/notifications/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => notificationsPageState();
}

class notificationsPageState extends State<NotificationsPage> {
  late List<Map<String, dynamic>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = []; // Initialize an empty list
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the notifications list here
    notifications = [
      {
        'id': 1,
        'title': 'tomorrows_gifts'.tr(context),
        'content': 'last_chance_delivery'.tr(context),
        'time': 'nine_days_ago'.tr(context),
        'type': 'gift',
        'isRead': false,
      },
      {
        'id': 2,
        'title': 'weekend_reward'.tr(context),
        'content': 'discount_offer'.tr(context),
        'time': 'nine_days_ago'.tr(context),
        'type': 'discount',
        'isRead': false,
      },
      {
        'id': 3,
        'title': 'tomorrows_gifts'.tr(context),
        'content': 'last_chance_delivery'.tr(context),
        'time': 'nine_days_ago'.tr(context),
        'type': 'gift',
        'isRead': true,
      },
      {
        'id': 4,
        'title': 'weekend_reward'.tr(context),
        'content': 'discount_offer'.tr(context),
        'time': 'nine_days_ago'.tr(context),
        'type': 'discount',
        'isRead': true,
      },
    ];
  }

  void _markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere(
        (notification) => notification['id'] == id,
      );
      if (index != -1) {
        notifications[index]['isRead'] = true;
      }
    });
  }

  void _deleteNotification(int id) {
    setState(() {
      notifications.removeWhere((notification) => notification['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'notifications'.tr(context),
              showBackButton: true,
              centerTitle: true,
              style: HeaderStyle.standard,
              onBackPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
            ),

            // Notifications list
            Expanded(
              child: notifications.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return NotificationItem(
                          title: notification['title'],
                          content: notification['content'],
                          time: notification['time'],
                          type: notification['type'],
                          isRead: notification['isRead'],
                          onTap: () => _markAsRead(notification['id']),
                          onDismiss: () =>
                              _deleteNotification(notification['id']),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64.h,
            color: Colors.grey,
          ),
          SizedBox(height: 16.h),
          Text(
            'nonotifications'.tr(context),
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'newnotifications_will_appear'.tr(context),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
