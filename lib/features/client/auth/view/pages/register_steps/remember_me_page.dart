import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/terms_conditions_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RememberMePage extends StatefulWidget {
  final String password;
  final String firstName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;

  const RememberMePage({
    super.key,
    required this.password,
    required this.firstName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
  });

  @override
  State<RememberMePage> createState() => _RememberMePageState();
}

class _RememberMePageState extends State<RememberMePage> {
  final bool _rememberMe = false;
  bool _isLoading = false;

  void _continue() {
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
          builder: (context) => TermsConditionsPage(
            password: widget.password,
            firstName: widget.firstName,
            dateOfBirth: widget.dateOfBirth,
            gender: widget.gender,
            phoneNumber: widget.phoneNumber,
            rememberMe: _rememberMe,
          ),
        ),
      );
    });
  }

  void _skipRememberMe() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TermsConditionsPage(
          password: widget.password,
          firstName: widget.firstName,
          dateOfBirth: widget.dateOfBirth,
          gender: widget.gender,
          phoneNumber: widget.phoneNumber,
          rememberMe: false,
        ),
      ),
    );
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
              showBackButton: false,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //! Step Indicator Section
                    const AppStepIndicator(
                      currentStep: 6,
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
                      question: 'save_login_info_prompt'.tr(context),
                      subtitle: 'save_login_info_description'.tr(context),
                    ),
                    SizedBox(height: 32.h),

                    //! Buttons Section (replacing the checkbox card)
                    AppButton(
                      text: 'save'.tr(context),
                      isLoading: _isLoading,
                      onPressed: _continue,
                      height: 50.h,
                      width: double.infinity,
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'not_now'.tr(context),
                      onPressed: _skipRememberMe,
                      height: 50.h,
                      type: AppButtonType.secondary,
                      width: double.infinity,
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
