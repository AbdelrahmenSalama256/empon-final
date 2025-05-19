import 'package:embone/features/client/auth/data/models/forget_password_model.dart';

class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgotPasswordLoading extends ForgetPasswordState {}

final class ForgotPasswordValidationFailed extends ForgetPasswordState {}

final class ForgotPasswordFailure extends ForgetPasswordState {
  final String message;
  ForgotPasswordFailure({required this.message});
}

final class ForgotPasswordSuccess extends ForgetPasswordState {
  final ForgotPasswordData? data;
  ForgotPasswordSuccess({this.data});
}

final class VerifyOtpLoading extends ForgetPasswordState {}

final class VerifyOtpValidationFailed extends ForgetPasswordState {}

final class VerifyOtpFailure extends ForgetPasswordState {
  final String message;
  VerifyOtpFailure({required this.message});
}

final class VerifyOtpSuccess extends ForgetPasswordState {}

final class ResetPasswordLoading extends ForgetPasswordState {}

final class ResetPasswordValidationFailed extends ForgetPasswordState {
  final String message;
  ResetPasswordValidationFailed({required this.message});
}

final class ResetPasswordFailure extends ForgetPasswordState {
  final String message;
  ResetPasswordFailure({required this.message});
}

final class ResetPasswordSuccess extends ForgetPasswordState {}
