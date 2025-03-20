import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/auth/view/pages/register_steps/create_password_page.dart';
import 'package:embone/features/auth/view/pages/register_steps/otp_verification_page.dart';
import 'package:embone/features/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhoneNumberPage extends StatefulWidget {
  final String firstName;
  final DateTime dateOfBirth;
  final Gender gender;

  const PhoneNumberPage({
    super.key,
    required this.firstName,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OtpVerificationPage(
        //       email: widget.firstName,
        //       password: widget.firstName,
        //       firstName: widget.firstName,
        //       dateOfBirth: widget.dateOfBirth,
        //       gender: widget.gender,
        //       phoneNumber: _phoneController.text,
        //     ),
        //   ),
        // );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreatePasswordPage(
              // email: widget.firstName,
              // password: widget.firstName,
              firstName: widget.firstName,
              dateOfBirth: widget.dateOfBirth,
              gender: widget.gender,
              phoneNumber: _phoneController.text,
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
                      // const AppStepIndicator(
                      //   currentStep: 4,
                      //   totalSteps: 8,
                      // ),
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
                        question: 'what_phone_number'.tr(context),
                        subtitle: 'phone_number_description'.tr(context),
                      ),
                      SizedBox(height: 32.h),
                      AppTextField(
                        controller: _phoneController,
                        labelText: 'phone_number'.tr(context),
                        hintText: 'enter_phone'.tr(context),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) =>
                            Validators.validatePhone(value, context),
                      ),
                      SizedBox(height: 32.h),
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
