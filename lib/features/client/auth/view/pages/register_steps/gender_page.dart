import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/gender_card_selection.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const GenderPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();

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
                      question: 'gender_selection_title'.tr(context),
                      subtitle: 'gender_description'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    GenderSelectionCard(
                      selectedGender: cubit.gender != null
                          ? Gender.values.firstWhere(
                              (e) =>
                                  e.toString().split('.').last == cubit.gender,
                              orElse: () => Gender.male,
                            )
                          : null, // No default selection
                      onGenderChanged: (Gender value) {
                        cubit.setGender(value.toString().split('.').last);
                      },
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'next'.tr(context),
                      isLoading: false,
                      onPressed: () {
                        if (cubit.gender == null) {
                          showToast(context,
                              message: 'please_select_gender'.tr(context),
                              state: ToastStates.error);
                          return;
                        }
                        PrintUtil.success('Selected gender: ${cubit.gender}');
                        widget.onNextStep();
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
