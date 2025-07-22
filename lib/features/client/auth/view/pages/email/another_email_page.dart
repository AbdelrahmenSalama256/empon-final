import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherEmailPage extends StatefulWidget {
  final VoidCallback onPreviousStep;
  final VoidCallback onNextStep;
  const AnotherEmailPage({
    super.key,
    required this.onPreviousStep,
    required this.onNextStep,
  });

  @override
  State<AnotherEmailPage> createState() => _AnotherEmailPageState();
}

class _AnotherEmailPageState extends State<AnotherEmailPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterError) {
            showToast(
              context,
              message: 'unexpected_error'.tr(context),
              state: ToastStates.error,
            );
          } else if (state is RegisterSuccess) {
            showToast(
              context,
              message: 'registration_successful'.tr(context),
              state: ToastStates.success,
            );
            widget.onNextStep();

            // navigateTo(
            //   context,
            //   BlocProvider(
            //     create: (context) => RegisterCubit(sl<RegisterRepo>()),
            //     child: const VerificationPage(),
            //   ),
            // );
          }
        },
        child: SafeArea(
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 32.h),
                          Image.asset(
                            'assets/images/email.png',
                            width: 360.w,
                            height: 240.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: 32.h),
                          Text(
                            'confirm_email_title'.tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(height: 20.h),
                          AppTextField(
                            controller: cubit.anotherEmailController,
                            hintText: 'email'.tr(context),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null; // Empty is valid
                              }
                              final emailRegExp =
                                  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                              if (!emailRegExp.hasMatch(value)) {
                                return 'please_enter_valid_another_email'
                                    .tr(context);
                              }
                              if (value == cubit.emailController.text) {
                                return 'another_email_must_be_different'
                                    .tr(context);
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'confirm_email_subtitle'.tr(context),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          AppButton(
                            text: 'finish'.tr(context),
                            isLoading: context.select<RegisterCubit, bool>(
                              (cubit) => cubit.state is RegisterLoading,
                            ),
                            onPressed: () {
                              cubit.register();
                            },
                            height: 50.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () => widget.onPreviousStep(),
                            child: Text(
                              'back'.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
