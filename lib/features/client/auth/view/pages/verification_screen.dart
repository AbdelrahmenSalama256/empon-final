import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

class VerificationPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const VerificationPage({super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (context.read<RegisterCubit>().resendSeconds == 60) {
      startResendTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (context.read<RegisterCubit>().resendSeconds > 0 && mounted) {
        context.read<RegisterCubit>().updateResendSeconds(
            context.read<RegisterCubit>().resendSeconds - 1);
        // context.read<RegisterCubit>().resendOtp(
        //     phone: context.read<RegisterCubit>().phoneController.text);

        setState(() {});
      } else {
        timer.cancel();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        return Scaffold(
          backgroundColor: Colors.white,
          body: BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is VerifyOtpError) {
                showToast(context,
                    message: state.message, state: ToastStates.error);
              }
              if (state is ResendOtpSuccess) {
                showToast(context,
                    message: 'otp_resent'.tr(context),
                    state: ToastStates.success);
              }
              if (state is VerifyOtpSuccess) {
                showToast(
                  context,
                  message: 'verification_successful'.tr(context),
                  state: ToastStates.success,
                );
                widget.onNextStep();
                // navigateAndFinish()
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const BaseScreen(),
                    //   ),
                    //   (route) => false,
                    // );
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  CustomHeader(
                    showBackButton: true,
                    showLogo: true,
                    onBackPressed: () =>
                        widget.onPreviousStep(),
                    title: 'verification'.tr(context),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 32.h),
                            Center(
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
                              cubit.phoneController.text.isNotEmpty
                                  ? 'verification_code_subtitle_phone'
                                      .tr(context)
                                  : 'verification_code_subtitle'.tr(context),
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
                              onPressed: () => cubit.verifyOtp(
                                phone: cubit.phoneController.text,
                              ),
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
                                          cubit.updateResendSeconds(0);
                                          startResendTimer();
                                          cubit.resendOtp(phone:cubit.phoneController.text);
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
          ),
        );
      },
    );
  }
}
