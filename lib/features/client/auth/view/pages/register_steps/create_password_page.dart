import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreatePasswordPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const CreatePasswordPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  State<CreatePasswordPage> createState() => _CreatePasswordPageState();
}

class _CreatePasswordPageState extends State<CreatePasswordPage> {
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
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppStepIndicator(currentStep: 5, totalSteps: 8),
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
                        question: 'what_password_requirements'.tr(context),
                        subtitle: 'password_instructions'.tr(context),
                      ),
                      SizedBox(height: 32.h),
                      AppTextField(
                        controller: cubit.passwordController,
                        labelText: 'password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          color: const Color(0xff8F95AB)
                              .withAlpha((0.7 * 255).toInt()),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, context),
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        controller: cubit.passwordConfirmationController,
                        labelText: 'confirm_password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          color: const Color(0xff8F95AB)
                              .withAlpha((0.7 * 255).toInt()),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          cubit.passwordController.text,
                          context,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      AppButton(
                        text: 'next'.tr(context),
                        isLoading: false,
                        onPressed: () {
                          if (cubit.passwordController.text.trim().isEmpty) {
                            showToast(context,
                                message: 'password_required'.tr(context),
                                state: ToastStates.error);
                            return;
                          }
                          if (cubit.passwordConfirmationController.text
                              .trim()
                              .isEmpty) {
                            showToast(context,
                                message:
                                    'confirm_password_required'.tr(context),
                                state: ToastStates.error);
                            return;
                          }
                          if (cubit.passwordController.text !=
                              cubit.passwordConfirmationController.text) {
                            showToast(context,
                                message: 'passwords_do_not_match'.tr(context),
                                state: ToastStates.error);
                            return;
                          }
                          widget.onNextStep();
                        },
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
