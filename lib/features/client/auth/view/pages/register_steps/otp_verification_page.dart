import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:pinput/pinput.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
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

  void _resendOtp() {
    if (_resendSeconds > 0) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _resendSeconds = 60;
      });

      _startResendTimer();

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('otp_resent'.tr(context))),
      );
    });
  }

  void _verifyOtp() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ResetPasswordPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'verification'.tr(context),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16.h),
                        const AppStepIndicator(
                          currentStep: 5,
                          totalSteps: 8,
                        ),
                        SizedBox(height: 32.h),
                        Text(
                          'enter_otp'.tr(context),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '${'otp_sent_to'.tr(context)} ${widget.phoneNumber}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Pinput(
                          controller: _otpControllers,
                          length: 4,
                          obscureText: false,
                          pinAnimationType: PinAnimationType.fade,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 32.h),
                        TextButton(
                          onPressed: _resendSeconds > 0 ? null : _resendOtp,
                          child: Text(
                            _resendSeconds > 0
                                ? '${'resend_code_in'.tr(context)} $_resendSeconds'
                                : 'resend_code'.tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: _resendSeconds > 0
                                  ? Colors.grey
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                        AppButton(
                          text: 'verify'.tr(context),
                          isLoading: _isLoading,
                          onPressed: _verifyOtp,
                          height: 50.h,
                          width: double.infinity,
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                            fontWeight: FontWeight.w400,
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
  }
}
