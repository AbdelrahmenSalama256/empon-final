import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/add_new_address_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionsPage extends StatefulWidget {
  final String password;
  final String firstName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final bool rememberMe;

  const TermsConditionsPage({
    super.key,
    required this.password,
    required this.firstName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.rememberMe,
  });

  @override
  State<TermsConditionsPage> createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
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
          builder: (context) => AddNewAddressPage(
            password: widget.password,
            firstName: widget.firstName,
            dateOfBirth: widget.dateOfBirth,
            gender: widget.gender,
            phoneNumber: widget.phoneNumber,
          ),
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
                      currentStep: 7,
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
                      question: 'terms_and_conditions'.tr(context),
                      subtitle: 'terms_and_conditions_description'.tr(context),
                    ),
                    SizedBox(height: 16.h),

                    //! Button Section
                    AppButton(
                      text: 'agree'.tr(context),
                      isLoading: _isLoading,
                      onPressed: _continue,
                      height: 50.h,
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
