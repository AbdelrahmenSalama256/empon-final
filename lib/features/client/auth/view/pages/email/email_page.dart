import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/email/another_email_page.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/profile/view/pages/add_profile_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/widgets/print_util.dart';

class EmailPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const EmailPage({
    super.key,
    required this.onNextStep,
    required this.onPreviousStep,
  });

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    final formKey = GlobalKey<FormState>();
return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
        if (state is VerifyEmailError) {
          PrintUtil.error('Email verification failed: ${state.error}');
          showToast(context, message: state.error, state: ToastStates.error);
        }
        if (state is VerifyEmailSuccess) {
          PrintUtil.success('Email verified successfully');
          showToast(context, message: state.message, state: ToastStates.success);
          widget.onNextStep();
          
        }},
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed:()=> widget.onPreviousStep(),
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
                          'add_email_title'.tr(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 32.h),
                        AppTextField(
                          controller: cubit.emailController,
                          hintText: 'email'.tr(context),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: const Color(0xff8F95AB)
                                .withAlpha((0.7 * 255).toInt()),
                            size: 24.sp,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'please_enter_email'.tr(context);
                            }
                            final emailRegExp =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegExp.hasMatch(value)) {
                              return 'please_enter_valid_email'.tr(context);
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'email_privacy_note'.tr(context),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        AppButton(
                          text: 'next'.tr(context),
                          isLoading: false,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              
                            cubit.verifyEmail(cubit.emailController.text);
                            } else {
                              showToast(
                                context,
                                message: 'please_enter_valid_email'.tr(context),
                                state: ToastStates.error,
                              );
                            }
                          },
                          height: 50.h,
                          width: double.infinity,
                        ),
                        SizedBox(height: 16.h),
                        TextButton(
                          onPressed:widget.onPreviousStep,
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
    );});
  }
}
