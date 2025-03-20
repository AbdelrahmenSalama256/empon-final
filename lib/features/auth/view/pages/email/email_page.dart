import 'dart:io';

import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/auth/view/pages/email/another_email_page.dart';
import 'package:embone/features/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailPage extends StatefulWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;
  const EmailPage(
      {super.key,
      required this.profileImage,
      required this.firstName,
      required this.selectedLocation,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.password});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
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

  void _continueWithEmail() {
    if (_isEmailValid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate email verification process
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AnotherEmailPage(email: _emailController.text),
          ),
        );
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
                        'add_email_title'.tr(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      // Email Input
                      AppTextField(
                        controller: _emailController,
                        hintText: 'email'.tr(context),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(Icons.email_outlined,
                            color: const Color(0xff8F95AB).withOpacity(0.7),
                            size: 24.sp),
                      ),
                      SizedBox(height: 20.h),

                      // Subtitle
                      Text(
                        'email_privacy_note'.tr(context),
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
                        text: 'next'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _isEmailValid ? _continueWithEmail : null,
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
