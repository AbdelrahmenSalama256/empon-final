class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError({required this.message});
}
