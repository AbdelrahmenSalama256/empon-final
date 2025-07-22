import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:embone/features/client/auth/view/pages/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/services/service_locator.dart';

class ForgotPasswordVerificationPage extends StatelessWidget {
  final String? phoneNumber;
  final String? firstName;
  final String? imageUrl;
  final String? email;

  const ForgotPasswordVerificationPage({
    super.key,
    this.phoneNumber,
    this.firstName,
    this.imageUrl,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";
    final cubit = context.read<ForgetPasswordCubit>();

    // Trigger initial OTP send
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (phoneNumber != null || email != null) {
        cubit.valueController.text = phoneNumber ?? email ?? '';
        cubit.forgotPassword();
      }
    });

    return BlocBuilder<ForgetPasswordCubit, ForgetPasswordState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
            listener: (context, state) {
              // Consolidated error handling for all failure states
              if (state is ForgotPasswordFailure ||
                  state is VerifyOtpFailure ||
                  state is ResendOtpFailure) {
                showToast(
                  context,
                  message: state is ForgotPasswordFailure
                      ? 'unexpected_error'.tr(context)
                      : state is VerifyOtpFailure
                          ? 'unexpected_error'.tr(context)
                          : (state as ResendOtpFailure).message.tr(context),
                  state: ToastStates.error,
                );
              } else if (state is ForgotPasswordSuccess) {
                showToast(
                  context,
                  message: 'otp_sent'.tr(context),
                  state: ToastStates.success,
                );
              } else if (state is VerifyOtpSuccess) {
                showToast(
                  context,
                  message: 'verification_successful'.tr(context),
                  state: ToastStates.success,
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordPage(
                      phoneNumber: phoneNumber,
                      firstName: firstName,
                      imageUrl: imageUrl,
                      email: email,
                    ),
                  ),
                );
              } else if (state is ResendOtpSuccess) {
                showToast(
                  context,
                  message: state.message.isNotEmpty
                      ? 'unexpected_error'.tr(context)
                      : 'otp_resent'.tr(context),
                  state: ToastStates.success,
                );
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  CustomHeader(
                    showBackButton: true,
                    showLogo: true,
                    title: 'verification'.tr(context),
                  ),
                  state is ResendOtpLoading || state is ForgotPasswordLoading
                      ? const Expanded(
                          child: Center(
                            child: CustomLoadingIndicator(),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Form(
                                key: cubit.formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 32.h),
                                    Container(
                                      width: 120.w,
                                      height: 120.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 2.w,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(60.r),
                                        child: Image.network(
                                          "$imageUrl",
                                          width: 120.w,
                                          height: 120.w,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                            "assets/images/logo.png",
                                            width: 120.w,
                                            height: 120.w,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Center(
                                              child: Icon(
                                                CupertinoIcons.person,
                                                size: 50.w,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      '${'welcome_back'.tr(context)} ${firstName ?? ""}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      'verification_code_title'.tr(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      phoneNumber != null
                                          ? 'verification_code_subtitle_phone'
                                              .tr(context)
                                          : 'verification_code_subtitle'
                                              .tr(context),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    if (state is ForgotPasswordFailure ||
                                        state is ResendOtpFailure) ...[
                                      Text(
                                        'failed_to_send_otp'.tr(context),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: AppColors.error,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 16.h),
                                      AppButton(
                                        text: 'retry_button'.tr(context),
                                        onPressed: () {
                                          cubit.valueController.text =
                                              phoneNumber ?? email ?? '';
                                          cubit.forgotPassword();
                                        },
                                        height: 50.h,
                                        width: 150.w,
                                      ),
                                      SizedBox(height: 16.h),
                                    ],
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24.w),
                                      child: Pinput(
                                        controller: cubit.otpController,
                                        length: 4,
                                        obscureText: false,
                                        pinAnimationType: PinAnimationType.fade,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          if (value.length == 4 &&
                                              (phoneNumber != null ||
                                                  email != null)) {
                                            cubit.verifyOtp(
                                                value: phoneNumber ?? email!);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(height: 32.h),
                                    AppButton(
                                      text: 'verify_button'.tr(context),
                                      isLoading: state is VerifyOtpLoading,
                                      onPressed: () {
                                        if (cubit.otpController.text.isEmpty ||
                                            (phoneNumber == null &&
                                                email == null)) {
                                          showToast(
                                            context,
                                            message: 'otp_empty'.tr(context),
                                            state: ToastStates.error,
                                          );
                                          return;
                                        }
                                        cubit.verifyOtp(
                                            value: phoneNumber ?? email!);
                                      },
                                      height: 50.h,
                                      width: double.infinity,
                                    ),
                                    SizedBox(height: 24.h),
                                    Directionality(
                                      textDirection: isRTL
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'didnt_receive_code'.tr(context),
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: cubit.resendSeconds >
                                                        0 ||
                                                    (phoneNumber == null &&
                                                        email == null)
                                                ? null
                                                : () {
                                                    cubit.resendOtp(
                                                        value: phoneNumber ??
                                                            email!);
                                                  },
                                            child: Text(
                                              cubit.resendSeconds > 0
                                                  ? '${'resend_code_in'.tr(context)} ${cubit.resendSeconds}'
                                                  : 'resend'.tr(context),
                                              style: TextStyle(
                                                color: cubit.resendSeconds > 0
                                                    ? AppColors.textSecondary
                                                    : AppColors.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
