import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/remember_me_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePasswordPage extends StatefulWidget {
  final String firstName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;

  const CreatePasswordPage({
    super.key,
    required this.firstName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
  });

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _passwordController.text = widget.password;
  // }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
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
            builder: (context) => RememberMePage(
              password: _passwordController.text,
              firstName: widget.firstName,
              dateOfBirth: widget.dateOfBirth,
              gender: widget.gender,
              phoneNumber: widget.phoneNumber,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            //! Header Section
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Step Indicator Section
                      const AppStepIndicator(
                        currentStep: 5,
                        totalSteps: 8,
                      ),
                      SizedBox(height: 16.h),

                      //! Image Section
                      Center(
                        child: Image.asset(
                          'assets/images/name.png',
                          width: 326.w,
                          height: 244.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      //! Question Section
                      QuestionWidget(
                        question: 'what_password_requirements'.tr(context),
                        subtitle: 'password_instructions'.tr(context),
                      ),
                      SizedBox(height: 32.h),

                      //! Password Input Section
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, context),
                      ),
                      SizedBox(height: 16.h),

                      //! Confirm Password Input Section
                      AppTextField(
                        controller: _confirmPasswordController,
                        labelText: 'confirm_password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          // ignore: deprecated_member_use
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
                      SizedBox(height: 16.h),

                      //! Button Section
                      AppButton(
                        text: 'next'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _continue,
                        height: 50.h,
                        width: double.infinity,
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
