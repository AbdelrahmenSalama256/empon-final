import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_date_picker.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/component/custom_toast.dart';

class DateOfBirthPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;

  const DateOfBirthPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  State<DateOfBirthPage> createState() => _DateOfBirthPageState();
}

class _DateOfBirthPageState extends State<DateOfBirthPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => widget.onPreviousStep(),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 16.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AppStepIndicator(currentStep: 2, totalSteps: 8),
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
                      question: 'birth_date'.tr(context),
                      subtitle: 'birth_date_description'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    AppDatePicker(
                      controller: cubit.birthDateController,
                      labelText: 'date_of_birth'.tr(context),
                      hintText: 'select_date'.tr(context),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                      onDateSelected: (date) {
                        cubit.birthDateController.text =
                            date.toIso8601String().split('T')[0];
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'next'.tr(context),
                      isLoading: false,
                      onPressed: () {
                        if (cubit.birthDateController.text.isEmpty) {
                          // Show error if no date is selected or parsing fails
                          showToast(context,
                              message: 'Please_select_a_valid_birth_date'.tr(context),
                              state: ToastStates.error);
                          return;
                        }
                        final selectedDate =
                            DateTime.tryParse(cubit.birthDateController.text)??null;

                        final today = DateTime.now();
                        final age = today.year -
                            selectedDate!.year -
                            ((today.month < selectedDate.month ||
                                    (today.month == selectedDate.month &&
                                        today.day < selectedDate.day))
                                ? 1
                                : 0);

                        if (age < 5) {
                          showToast(context,
                              message: 'You_must_be_at_least_5_years_old_to_continue'.tr(context),
                              state: ToastStates.error);
                          
                        } else {
                          widget.onNextStep();
                        }
                      },
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
