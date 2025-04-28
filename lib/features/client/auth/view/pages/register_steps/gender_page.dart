import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/phone_number_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/gender_card_selection.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;

  const GenderPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
  });

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  Gender _selectedGender = Gender.male; // Non-nullable with default value
  bool _isLoading = false;

  void _continue() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneNumberPage(
            firstName: widget.firstName,
            dateOfBirth: widget.dateOfBirth,
            gender: _selectedGender, // Non-nullable Gender
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
            CustomHeader(
              showBackButton: true,
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
                    const AppStepIndicator(currentStep: 3, totalSteps: 8),
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
                    QuestionWidget(
                      question: 'what_gender'.tr(context),
                      subtitle: 'gender_description'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    GenderSelectionCard(
                      selectedGender: _selectedGender,
                      onGenderChanged: (Gender value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'next'.tr(context),
                      isLoading: _isLoading,
                      onPressed: _continue,
                      height: 50.h,
                      isFullWidth: true,
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
