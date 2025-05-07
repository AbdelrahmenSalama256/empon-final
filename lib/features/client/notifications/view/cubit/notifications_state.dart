part of 'notifications_cubit.dart';

sealed class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError({required this.message});
}
