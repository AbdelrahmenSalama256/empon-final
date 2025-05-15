import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/auth/data/models/forget_password_model.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo forgetPasswordRepo;
  final TextEditingController valueController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  int resendSeconds = 60;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ForgetPasswordCubit(this.forgetPasswordRepo) : super(ForgetPasswordInitial());
  Future<void> forgotPassword() async {
    emit(ForgotPasswordLoading());
    final value = valueController.text.trim();

    if (!formKey.currentState!.validate()) {
      emit(ForgotPasswordValidationFailed());
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

    if (!formKey.currentState!.validate() || password != confirmPassword) {
      emit(const ResetPasswordValidationFailed(
          message: 'Passwords do not match'));
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

  @override
  Future<void> close() {
    valueController.dispose();
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  void updateResendSeconds(int seconds) {
    resendSeconds = seconds;

    emit(ForgetPasswordInitial());
  }
}
