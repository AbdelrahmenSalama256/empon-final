import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_date_picker.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/auth/view/pages/register_steps/gender_page.dart';
import 'package:embone/features/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateOfBirthPage extends StatefulWidget {
  final String firstName;
  final String lastName;

  const DateOfBirthPage({
    super.key,
    required this.firstName,
    required this.lastName,
  });

  @override
  State<DateOfBirthPage> createState() => _DateOfBirthPageState();
}

class _DateOfBirthPageState extends State<DateOfBirthPage> {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _dobController.dispose();
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
            builder: (context) => GenderPage(
              firstName: widget.firstName,
              lastName: widget.lastName,
              dateOfBirth: _selectedDate!,
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
                    vertical: 16.h), // Adjusted padding for responsiveness
                child: Form(
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
                          fit: BoxFit
                              .contain, // Ensure the image scales properly
                        ),
                      ),
                      SizedBox(height: 32.h),
                      QuestionWidget(
                        question: 'birth_date'.tr(context),
                        subtitle: 'birth_date_description'.tr(context),
                      ),
                      SizedBox(height: 32.h),
                      AppDatePicker(
                        controller: _dobController,
                        labelText: 'date_of_birth'.tr(context),
                        hintText: 'select_date'.tr(context),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'date_required'.tr(context);
                        //   }
                        //   return null;
                        // },
                        validator: (value) => Validators.validateRequired(
                            value, 'date_of_birth'.tr(context), context),
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date.isUtc ? date : date.toUtc();
                          });
                        },
                      ),
                      SizedBox(height: 32.h),
                      AppButton(
                        text: 'next'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _continue,
                        height: 50.h,
                        width: double.infinity,
                        type: AppButtonType.primary,
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
