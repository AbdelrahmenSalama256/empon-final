import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

class VerificationPage extends StatefulWidget {
  final String phoneNumber;

  const VerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _otpControllers = TextEditingController();
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  bool _isLoading = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpControllers.dispose();
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _verifyOtp() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      navigateAndFinish(context, const BaseScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),

                      // Lock illustration
                      SizedBox(height: 16.h),
                      Center(
                        child: Image.asset(
                          'assets/images/name.png',
                          width: 326.w,
                          height: 244.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Title
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

                      // Subtitle
                      Text(
                        'verification_code_subtitle'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      /// OTP input fields
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Pinput(
                          controller: _otpControllers,
                          length: 4,
                          obscureText: false,
                          pinAnimationType: PinAnimationType.fade,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Verify button
                      AppButton(
                        text: 'verify_button'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _verifyOtp,
                        height: 50.h,
                        width: double.infinity,
                      ),
                      SizedBox(height: 24.h),

                      // Didn't receive code
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
                            onPressed: _resendSeconds > 0
                                ? null
                                : () {
                                    setState(() {
                                      _resendSeconds = 60;
                                    });
                                    _startResendTimer();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('otp_resent'.tr(context))),
                                    );
                                  },
                            child: Text(
                              _resendSeconds > 0
                                  ? '${'resend_code_in'.tr(context)} $_resendSeconds'
                                  : 'resend'.tr(context),
                              style: TextStyle(
                                color: _resendSeconds > 0
                                    ? AppColors.textSecondary
                                    : AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // // Progress indicator
                      // Padding(
                      //   padding: EdgeInsets.symmetric(vertical: 16.h),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         '6/7',
                      //         style: TextStyle(
                      //           fontSize: 12.sp,
                      //           color: AppColors.textSecondary,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
  }
}
