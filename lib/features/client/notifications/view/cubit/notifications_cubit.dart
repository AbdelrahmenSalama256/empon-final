import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/notifications/data/model/notifications_model.dart';
import 'package:embone/features/client/notifications/data/repo/notifications_repo.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo notificationsRepo;

  NotificationsCubit(this.notificationsRepo) : super(NotificationsInitial());
  init() {
    fetchNotifications();
  }

  NotificationsModel? notificationsModel;

  Future<void> fetchNotifications() async {
    emit(NotificationsLoading());
    final response = await notificationsRepo.getNotifications();
    Print.info(response);

    response.fold(
      (l) {
        Print.error(l);
        emit(NotificationsError(message: l));
      },
      (r) {
        notificationsModel = r;
        Print.info(notificationsModel);

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
}
