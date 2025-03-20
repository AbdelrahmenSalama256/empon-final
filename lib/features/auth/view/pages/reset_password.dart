import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/auth/view/pages/login_screen.dart';
import 'package:embone/features/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('password_reset_success'.tr(context))),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: '',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2.w,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Image.asset(
                            'assets/images/profile.png',
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                CupertinoIcons.person,
                                size: 40.w,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Abdulrahmen',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'identity_verification_message'.tr(context),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      ),
                      SizedBox(height: 32.h),
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'new_password'.tr(context),
                        hintText: '****',
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, context),
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: _confirmPasswordController,
                        labelText: 'confirm_password'.tr(context),
                        hintText: '****',
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.lock_outlined,
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                          context,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      AppButton(
                        text: 'confirm'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _resetPassword,
                        height: 50.h,
                        width: double.infinity,
                        textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16.h),
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
