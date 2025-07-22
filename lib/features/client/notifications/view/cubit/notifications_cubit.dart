import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/notifications/data/model/notifications_model.dart';
import 'package:embone/features/client/notifications/data/repo/notifications_repo.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;
  NotificationsModel? notificationsModel;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial());

  void init() {
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final response = await notificationsRepo.getNotifications();
    Print.info('Response from repo: $response');

    response.fold(
      (failure) {
        Print.error('Fetch failed: $failure');
        emit(NotificationsError(message: failure));
      },
      (model) {
        notificationsModel = model;
        Print.info('Fetched notifications model: $notificationsModel');
        Print.success('Notifications fetched successfully');
        emit(NotificationsSuccess());
      },
    );
  }

  void markAsRead(int id) {
    if (notificationsModel == null) return;

    final updatedNotifications =
        notificationsModel!.notifications.map((notification) {
      if (notification.id == id) {
        return NotificationItem(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          type: notification.type,
          isRead: true,
          time: notification.time,
          notifiableType: notification.notifiableType,
          notifiableId: notification.notifiableId,
        );
      }
      return notification;
    }).toList();

    notificationsModel = NotificationsModel(
      success: notificationsModel!.success,
      message: notificationsModel!.message,
      notifications: updatedNotifications,
    );

    emit(NotificationsSuccess());
  }

  void deleteNotification(int id) {
    if (notificationsModel == null) return;

    final updatedNotifications = notificationsModel!.notifications
        .where((notification) => notification.id != id)
        .toList();

    notificationsModel = NotificationsModel(
      success: notificationsModel!.success,
      message: notificationsModel!.message,
      notifications: updatedNotifications,
    );

    emit(NotificationsSuccess());
  }

  void handleNotificationUpdate(Map<String, dynamic> notificationData) {
    Print.info('Handling notification update with data: $notificationData');
    if (notificationData['type'] != null) {
      try {
        final String type = notificationData['type'] as String;
        final dynamic accountIdDynamic = notificationData['account_id'];
        final dynamic verifiedDynamic = notificationData['verified'];

        // Convert account_id to int safely
        final int? accountId = accountIdDynamic is String
            ? int.tryParse(accountIdDynamic)
            : accountIdDynamic as int?;
        // Convert verified to int safely, default to 0 if invalid
        final int? verified = verifiedDynamic is String
            ? int.tryParse(verifiedDynamic) ?? 0
            : verifiedDynamic as int?;

        if (type == 'account_verification' &&
            (accountId == null || verified == null)) {
          Print.error(
              'Missing or invalid required fields in notification data: accountId=$accountId, verified=$verified');
          return;
        }

        if (type == 'account_verification' || type == 'default') {
          final newNotification = NotificationItem(
            id: DateTime.now().millisecondsSinceEpoch, // Temporary ID
            title: 'Account Verification',
            body:
                'Your account with ID ${accountId ?? 0} has been ${verified == 1 ? 'verified' : 'not verified'}',
            type: type,
            isRead: false,
            time: DateTime.now().toIso8601String(),
            notifiableType: 'Account',
            notifiableId: accountId ?? 0,
          );

          if (notificationsModel != null) {
            final updatedNotifications =
                List<NotificationItem>.from(notificationsModel!.notifications)
                  ..insert(0, newNotification);
            notificationsModel = NotificationsModel(
              success: notificationsModel!.success,
              message: notificationsModel!.message,
              notifications: updatedNotifications,
            );
            Print.success('Notification added to model: $newNotification');
            emit(NotificationsSuccess()); // Ensure UI updates
          } else {
            Print.error('notificationsModel is null, cannot update');
          }
        } else {
          Print.info('Notification type $type not handled');
        }
      } catch (e) {
        Print.error('Error processing notification update: $e');
      }
    } else {
      Print.error('No type field in notification data');
    }
  }
}
