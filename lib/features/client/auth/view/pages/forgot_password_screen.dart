import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/forget_password_verification.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordVerificationPage(
              email: _emailController.text,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Custom Header (if available)
                  CustomHeader(
                    showBackButton: true,
                    showLogo: true,
                    onBackPressed: () => Navigator.pop(context),
                    title: 'forgot_password'.tr(context),
                  ),
                  SizedBox(height: 16.h),
                  Center(
                    child: Image.asset(
                      'assets/images/name.png',
                      width: 326.w,
                      height: 244.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 32.h.h),
                  // Title
                  Text(
                    'reset_password_title'.tr(context),
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
                    'reset_password_subtitle'.tr(context),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 32.h.h),

                  // Email field
                  AppTextField(
                    controller: _emailController,
                    labelText: 'email'.tr(context),
                    hintText: 'enter_email'.tr(context),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      // ignore: deprecated_member_use
                      color: const Color(0xff8F95AB).withOpacity(0.7),
                      size: 24.sp,
                    ),
                    validator: (value) =>
                        Validators.validateEmail(value, context),
                  ),
                  SizedBox(height: 24.h),

                  // Send button
                  AppButton(
                    text: 'send_reset_link'.tr(context),
                    isLoading: _isLoading,
                    onPressed: _sendResetLink,
                    height: 56.h,
                  ),
                  SizedBox(height: 16.h),

                  // Return to login
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'return_to_login'.tr(context),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
