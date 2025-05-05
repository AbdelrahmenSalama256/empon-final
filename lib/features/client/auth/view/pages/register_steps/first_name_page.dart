import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstNamePage extends StatelessWidget {
  final VoidCallback onNextStep;

  const FirstNamePage({super.key, required this.onNextStep});

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
              onBackPressed: () => Navigator.pop(context),
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
                    const AppStepIndicator(currentStep: 1, totalSteps: 8),
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
                      question: 'what_name'.tr(context),
                      subtitle: 'what_name_descreption'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: cubit.firstNameController,
                            labelText: 'first_name'.tr(context),
                            hintText: 'enter_name'.tr(context),
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color:
                                  // ignore: deprecated_member_use
                                  const Color(0xff8F95AB)
                                      .withAlpha((0.7 * 255).toInt()),
                              size: 24.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: AppTextField(
                            controller: cubit.lastNameController,
                            labelText: 'last_name'.tr(context),
                            hintText: 'enter_name'.tr(context),
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color:
                                  // ignore: deprecated_member_use
                                  const Color(0xff8F95AB)
                                      .withAlpha((0.7 * 255).toInt()),
                              size: 24.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'next'.tr(context),
                      isLoading: false,
                      onPressed: () {
                        if (cubit.firstNameController.text.trim().isEmpty) {
                          showToast(context,
                              message: 'first_name_required'.tr(context),
                              state: ToastStates.error);
                          return;
                        }
                        if (cubit.lastNameController.text.trim().isEmpty) {
                          showToast(context,
                              message: 'last_name_required'.tr(context),
                              state: ToastStates.error);
                          return;
                        }
                        cubit.setCurrentStep(1);
                        onNextStep();
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
