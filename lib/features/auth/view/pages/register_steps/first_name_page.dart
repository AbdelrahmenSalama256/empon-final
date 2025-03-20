import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/auth/view/pages/register_steps/date_of_birth_page.dart';
import 'package:embone/features/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstNamePage extends StatefulWidget {
  const FirstNamePage({
    super.key,
  });

  @override
  State<FirstNamePage> createState() => _FirstNamePageState();
}

class _FirstNamePageState extends State<FirstNamePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DateOfBirthPage(
              firstName: _firstNameController.text,
              lastName: _lastNameController.text,
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
                padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 16.h), // Adjusted for responsiveness
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // const AppStepIndicator(currentStep: 1, totalSteps: 8),
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
                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  controller: _firstNameController,
                                  labelText: 'first_name'.tr(context),
                                  hintText: 'enter_name'.tr(context),
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Icon(
                                    CupertinoIcons.person,
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
                                    size: 24.w,
                                  ),
                                  validator: (value) =>
                                      Validators.validateRequired(value,
                                          'first_name'.tr(context), context),
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: AppTextField(
                                  controller: _lastNameController,
                                  labelText: 'last_name'.tr(context),
                                  hintText: 'enter_name'.tr(context),
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: Icon(
                                    CupertinoIcons.person,
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
                                    size: 24.w,
                                  ),
                                  validator: (value) =>
                                      Validators.validateRequired(value,
                                          'last_name'.tr(context), context),
                                ),
                              ),
                            ],
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
