part of 'global_cubit.dart';

sealed class GlobalState extends Equatable {
  const GlobalState();

  @override
  List<Object> get props => [];
}

final class GlobalInitial extends GlobalState {}

final class BottomNavChangeState extends GlobalState {}

// Any Other State You May Need
class LoadingState extends GlobalState {}

class ErrorState extends GlobalState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}

class LanguageChangeState extends GlobalState {}

class UserTypeLoadedState extends GlobalState {}

class UserTypeChangedState extends GlobalState {}

class ProfileLoading extends GlobalState {
  const ProfileLoading();
}

class ProfileLoaded extends GlobalState {
  const ProfileLoaded();
}

class ProfileError extends GlobalState {
  final String message;

  const ProfileError(this.message);
}

class LogoutLoading extends GlobalState {
  const LogoutLoading();
}

class LogoutSuccess extends GlobalState {
  final String message;

  const LogoutSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LogoutError extends GlobalState {
  final String message;

  const LogoutError(this.message);

  @override
  List<Object> get props => [message];
}
