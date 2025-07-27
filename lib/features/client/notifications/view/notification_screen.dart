import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_cubit.dart';
import 'package:embone/features/client/notifications/view/widgets/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/custom_popup.dart';
import '../../../../core/constants/navigation.dart';
import '../../menu/view/inner_screens/customer_support_chat_screen.dart';
import '../../order/view/order_details_screen.dart';
import '../../product_Details/view/product_details_screen.dart';
import '../../product_Details/view/service_detailes_secreen.dart';
import '../data/model/notifications_model.dart';
import 'cubit/notifications_state.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchNotifications();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh notifications when app comes to foreground
      _fetchNotifications();
    }
  }

  Future<void> _fetchNotifications() async {
    await context.read<NotificationsCubit>().fetchNotifications();
  }

  void _handleNotificationTap(NotificationItem notification) {
    debugPrint('Notification tapped: ${notification.type}');

    final cubit = context.read<NotificationsCubit>();
    final globalCubit = context.read<GlobalCubit>();

    // Mark as read when tapped
    if (!notification.isRead) {
      cubit.markAsRead(notification.id);
    }

    // First remove all escaping backslashes, then compare
    final cleanType = notification.type.replaceAll(r'\', '');
    debugPrint('Clean type: $cleanType');

    switch (cleanType) {
      case 'AppModelsAccountTrue':
        debugPrint('Handling account true notification');
        if (notification.notifiableId != null) {
          // If already a business user, don't switch again
          if (globalCubit.userType == UserType.business) {
            debugPrint('Already a business user, no action needed');
            return;
          }

          // Switch to business account
          globalCubit.setBusinessId(notification.notifiableId);
          globalCubit.setUserType(UserType.business);
          globalCubit.changeBottomNavIndex(0);
          showToast(context,
              message: 'Switched to business account',
              state: ToastStates.success);
        }
        break;

      case 'AppModelsAccountFalse':
        debugPrint('Handling account false notification');
        // If currently a business user, switch back to client
        if (globalCubit.userType == UserType.business) {
          globalCubit.setUserType(UserType.client);
          globalCubit.changeBottomNavIndex(0);
          showToast(context,
              message: 'Switched back to client account',
              state: ToastStates.success);
        }

        // Show deactivation message
        CustomPopup.show(
          context: context,
          title: 'inactive_account_title'.tr(context),
          message: 'inactive_account_message'.tr(context),
          type: PopupType.alert,
          primaryButtonText: 'ok'.tr(context),
          onPrimaryButtonPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        );
        break;

      case 'AppModelsProduct':
        debugPrint('Navigating to product detail');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              productId: notification.notifiableId,
            ),
          ),
        );
        break;

      case 'AppModelsService':
        debugPrint('Navigating to service detail');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetailPage(
              isVendor: false,
              serviceId: notification.notifiableId,
            ),
          ),
        );
        break;

      case 'AppModelsProductorder':
        debugPrint('Navigating to order details');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              orderId: notification.notifiableId,
            ),
          ),
        );
        break;
      case 'AppModelsSupportConversation':
        debugPrint('Navigating to customer support chat');
        navigateWithoutNav(
          context,
          const CustomerSupportChatScreen(),
        );
        break;

      default:
        debugPrint('Unknown notification type: $cleanType');
        showToast(context,
            message: notification.body, state: ToastStates.success);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<NotificationsCubit>();
        final notifications = cubit.notificationsModel?.notifications ?? [];

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

                // Notifications list with RefreshIndicator
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _fetchNotifications,
                    child: _buildContent(state, notifications),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
      NotificationsState state, List<NotificationItem> notifications) {
    if (state is NotificationsLoading) {
      return const Center(child: CustomLoadingIndicator());
    } else if (state is NotificationsError) {
      return Center(
        child: EmptyMessageWidget(message: state.message.tr(context)),
      );
    } else if (notifications.isEmpty) {
      return _buildEmptyState();
    } else {
      return ListView.builder(
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
            onTap: () => _handleNotificationTap(notification),
          );
        },
      );
    }
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
