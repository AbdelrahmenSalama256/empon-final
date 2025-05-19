class LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;

  LoginError({required this.message});
}

class LoginSuccess extends LoginState {
  final bool isVerified;
  final bool? isEmail;

  LoginSuccess(this.isEmail, {required this.isVerified});
}
