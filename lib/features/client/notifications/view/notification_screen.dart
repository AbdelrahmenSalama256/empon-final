// ignore_for_file: camel_case_types

import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_cubit.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_state.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final notifications = context
                .read<NotificationsCubit>()
                .notificationsModel
                ?.notifications ??
            [];
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
                  child: state is NotificationsLoading
                      ? const Center(child: CustomLoadingIndicator())
                      : state is NotificationsError
                          ? Center(
                              child: EmptyMessageWidget(
                                  message: state.message.tr(context)))
                          : notifications.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    return NotificationItemList(
                                      title: notification.title,
                                      content: notification.body,
                                      time: notification.time,
                                      type: notification.type,
                                      isRead: notification.isRead,
                                    );
                                  },
                                ),
                ),
              ],
            ),
          ),
        );
      },
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
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'newnotifications_will_appear'.tr(context),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
