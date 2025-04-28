import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/verification_screen.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherEmailPage extends StatefulWidget {
  final String email;

  const AnotherEmailPage({
    super.key,
    required this.email,
  });

  @override
  State<AnotherEmailPage> createState() => _AnotherEmailPageState();
}

class _AnotherEmailPageState extends State<AnotherEmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _emailController.addListener(_validateEmail);
    _validateEmail(); // Initial validation
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(_emailController.text);
    });
  }

  void _finishSetup() {
    if (_isEmailValid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate completion process
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(phoneNumber: widget.email),
            ),
            (route) => false);

        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    }
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
              showBackButton: false,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),

                      // Illustration
                      Image.asset(
                        'assets/images/email.png',
                        width: 360.w,
                        height: 240.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 32.h),

                      // Title
                      Text(
                        'confirm_email_title'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      SizedBox(height: 20.h),

                      // Email Input
                      AppTextField(
                        controller: _emailController,
                        hintText: 'email'.tr(context),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      SizedBox(height: 20.h),
                      // Subtitle
                      Text(
                        'confirm_email_subtitle'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // Buttons
                      AppButton(
                        text: 'finish'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _isEmailValid ? _finishSetup : null,
                        height: 50.h,
                        width: double.infinity,
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'back'.tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
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
