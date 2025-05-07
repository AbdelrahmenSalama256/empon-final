part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

final class ForgetPasswordInitial extends ForgetPasswordState {}

final class ForgotPasswordLoading extends ForgetPasswordState {}

final class ForgotPasswordValidationFailed extends ForgetPasswordState {}

final class ForgotPasswordFailure extends ForgetPasswordState {
  final String message;
  const ForgotPasswordFailure({required this.message});
}

final class ForgotPasswordSuccess extends ForgetPasswordState {
  final ForgotPasswordData? data;
  const ForgotPasswordSuccess({this.data});
}

final class VerifyOtpLoading extends ForgetPasswordState {}

final class VerifyOtpValidationFailed extends ForgetPasswordState {}

final class VerifyOtpFailure extends ForgetPasswordState {
  final String message;
  const VerifyOtpFailure({required this.message});
}

final class VerifyOtpSuccess extends ForgetPasswordState {}

final class ResetPasswordLoading extends ForgetPasswordState {}

final class ResetPasswordValidationFailed extends ForgetPasswordState {
  final String message;
  const ResetPasswordValidationFailed({required this.message});
}

final class ResetPasswordFailure extends ForgetPasswordState {
  final String message;
  const ResetPasswordFailure({required this.message});
}

final class ResetPasswordSuccess extends ForgetPasswordState {}
