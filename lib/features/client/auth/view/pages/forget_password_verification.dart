import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/pages/reset_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

class ForgotPasswordVerificationPage extends StatefulWidget {
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
  State<ForgotPasswordVerificationPage> createState() =>
      _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState
    extends State<ForgotPasswordVerificationPage> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return BlocProvider(
      create: (context) => ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is VerifyOtpFailure) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is VerifyOtpSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) =>
                      ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
                  child: ResetPasswordPage(
                    phoneNumber: widget.phoneNumber,
                    firstName: widget.firstName,
                    imageUrl: widget.imageUrl,
                    email: widget.email,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgetPasswordCubit>();

          void startResendTimer() {
            _timer?.cancel();
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (cubit.resendSeconds > 0) {
                cubit.updateResendSeconds(cubit.resendSeconds - 1);
                setState(() {});
              } else {
                timer.cancel();
                setState(() {});
              }
            });
          }

          if (cubit.resendSeconds == 60) {
            startResendTimer();
          }

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Header Section
                  CustomHeader(
                    showBackButton: true,
                    showLogo: true,
                    onBackPressed: () => Navigator.pop(context),
                    title: 'verification'.tr(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 32.h),
                              // Profile Image
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
                                  borderRadius: BorderRadius.circular(60.r),
                                  child: Image.network(
                                    widget.imageUrl ??
                                        'assets/images/profile.png',
                                    width: 120.w,
                                    height: 120.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Image.asset(
                                      "assets/images/profile.png",
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
                                '${'welcome_back'.tr(context)} ${widget.firstName ?? ""}',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: QuestionWidget(
                                  question:
                                      'enter_verification_code'.tr(context),
                                  subtitle:
                                      'verification_code_hint'.tr(context),
                                ),
                              ),
                              SizedBox(height: 32.h),
                              // OTP Input
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Pinput(
                                  controller: cubit.otpController,
                                  length: 4,
                                  obscureText: false,
                                  pinAnimationType: PinAnimationType.fade,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(height: 32.h),
                              // Verify Button
                              AppButton(
                                text: 'verify_button'.tr(context),
                                isLoading: state is VerifyOtpLoading,
                                onPressed: () {
                                  if (cubit.otpController.text.isEmpty ||
                                      widget.phoneNumber == null) {
                                    showToast(
                                      context,
                                      message: 'otp_empty'.tr(context),
                                      state: ToastStates.error,
                                    );
                                    return;
                                  } else {
                                    cubit.verifyOtp(
                                      value: widget.phoneNumber ?? "",
                                    );
                                  }
                                },
                                height: 50.h,
                                width: double.infinity,
                              ),
                              SizedBox(height: 24.h),
                              // Resend Code
                              Directionality(
                                textDirection: isRTL
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'didnt_receive_code'.tr(context),
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: cubit.resendSeconds > 0
                                          ? null
                                          : () {
                                              cubit.updateResendSeconds(60);
                                              startResendTimer();
                                              showToast(
                                                context,
                                                message:
                                                    'otp_resent'.tr(context),
                                                state: ToastStates.success,
                                              );
                                              cubit
                                                  .forgotPassword(); // Re-trigger forgot password to resend OTP
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
          );
        },
      ),
    );
  }
}
