import 'dart:async';

import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String? type;

  const OtpVerificationPage({
    super.key,
    this.type,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(sl<RegisterRepo>()),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is VerifyOtpError) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is VerifyOtpSuccess) {
            if (widget.type == "profile" || widget.type == "verify-phone") {
              Navigator.pop(context);
            } else {
              navigateAndFinish(context, const BaseScreen());
            }
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();

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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(height: 16.h),
                            // const AppStepIndicator(
                            //   currentStep: 5,
                            //   totalSteps: 8,
                            // ),
                            //! Profile Image
                            SizedBox(height: 32.h),
                            widget.type != null
                                ? Center(
                                    child: ProfileSection(
                                      userName:
                                          "${context.read<GlobalCubit>().firstNameController.text} ${context.read<GlobalCubit>().lastNameController.text}"
                                              .trim(),
                                      userImageUrl: context
                                              .read<GlobalCubit>()
                                              .userAvatar ??
                                          'assets/images/logo.png',
                                      subtitle: '',
                                      isVendor: false,
                                      onTap: () {
                                        // Handle tap action if needed (e.g., show dialog or navigate)
                                        // For now, this is a placeholder
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Image.asset(
                                      'assets/images/name.png',
                                      width: 326.w,
                                      height: 244.h,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                            SizedBox(height: 32.h),
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
                              '${'otp_sent_to'.tr(context)} ${widget.phoneNumber}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 32.h),
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
                            AppButton(
                              text: 'verify_button'.tr(context),
                              isLoading: state is VerifyOtpLoading,
                              onPressed: () {
                                cubit.phoneController.text = widget.phoneNumber;
                                if (cubit.otpController.text.isEmpty) {
                                  showToast(
                                    context,
                                    message: 'otp_empty'.tr(context),
                                    state: ToastStates.error,
                                  );
                                  return;
                                } else {
                                  cubit.verifyOtp(
                                    phone: cubit.phoneController.text,
                                  );
                                }
                              },
                              height: 50.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 24.h),
                            Row(
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
                                            message: 'otp_resent'.tr(context),
                                            state: ToastStates.success,
                                          );
                                          cubit.resendOtp(
                                              phone:
                                                  cubit.phoneController.text);
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
                            SizedBox(height: 30.h),
                          ],
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
