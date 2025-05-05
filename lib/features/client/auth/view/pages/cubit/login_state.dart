part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});
}

class LoginSuccess extends LoginState {
  final bool isVerified;
  final bool? isEmail;

  const LoginSuccess(this.isEmail, {required this.isVerified});
}
