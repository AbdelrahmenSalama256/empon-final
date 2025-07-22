import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:flutter/material.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo forgetPasswordRepo;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  int resendSeconds = 60;
  Timer? _timer;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgetPasswordCubit(this.forgetPasswordRepo) : super(ForgetPasswordInitial());

  Future<void> forgotPassword() async {
    emit(ForgotPasswordLoading());
    final value = valueController.text.trim();

    // Skip validation if formKey.currentState is null
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      emit(ForgotPasswordValidationFailed());
      return;
    }

    if (value.isEmpty) {
      Print.error('Value is empty');
      emit(ForgotPasswordFailure(message: 'phone_or_email_required'));
      return;
    }

    final response = await forgetPasswordRepo.forgotPassword(value);
    response.fold(
      (l) {
        Print.error(l);
        emit(ForgotPasswordFailure(message: l));
      },
      (r) {
        Print.success('Password reset initiated');
        emit(ForgotPasswordSuccess(data: r));
        startResendTimer();
      },
    );
  }

  Future<void> verifyOtp({required String value}) async {
    emit(VerifyOtpLoading());
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      emit(VerifyOtpValidationFailed());
      return;
    }

    final response =
        await forgetPasswordRepo.verifyOtp(value, otpController.text);
    response.fold(
      (l) {
        Print.error(l);
        emit(VerifyOtpFailure(message: l));
      },
      (r) {
        Print.success(r);
        emit(VerifyOtpSuccess());
      },
    );
  }

  Future<void> resetPassword() async {
    emit(ResetPasswordLoading());
    final value = valueController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (formKey.currentState != null && !formKey.currentState!.validate() ||
        password != confirmPassword) {
      emit(ResetPasswordValidationFailed(message: 'Passwords do not match'));
      return;
    }

    final response = await forgetPasswordRepo.resetPassword(
        value, password, confirmPassword);
    response.fold(
      (l) {
        Print.error(l);
        emit(ResetPasswordFailure(message: l));
      },
      (r) {
        Print.success(r);
        emit(ResetPasswordSuccess());
      },
    );
  }

  Future<void> resendOtp({required String value}) async {
    if (isClosed) return;

    emit(ResendOtpLoading());
    final response = await sl<RegisterRepo>().resendOtp(phone: value);
    if (isClosed) return;

    response.fold(
      (error) {
        Print.error('Resend OTP failed: $error');
        emit(ResendOtpFailure(message: error));
      },
      (result) {
        Print.success('OTP resent successfully: $result');
        emit(ResendOtpSuccess(message: result.message ?? ''));
        startResendTimer();
      },
    );
  }

  void startResendTimer() {
    _timer?.cancel();
    resendSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds > 0 && !isClosed) {
        resendSeconds--;
        emit(ResendOtpTimerUpdated(resendSeconds));
      } else {
        timer.cancel();
        emit(ResendOtpTimerUpdated(0));
      }
    });
  }

  void stopResendTimer() {
    _timer?.cancel();
    emit(ResendOtpTimerUpdated(resendSeconds));
  }

  void updateResendSeconds(int seconds) {
    resendSeconds = seconds;
    emit(ResendOtpTimerUpdated(seconds));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    valueController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
