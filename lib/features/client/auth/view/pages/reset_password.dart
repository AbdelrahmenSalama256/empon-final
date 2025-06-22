import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordPage extends StatelessWidget {
  final String? phoneNumber;
  final String? firstName;
  final String? imageUrl;
  final String? email;

  const ResetPasswordPage({
    super.key,
    this.phoneNumber,
    this.firstName,
    this.imageUrl,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordFailure) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is ResetPasswordSuccess) {
            showToast(
              context,
              message: 'password_reset_success'.tr(context),
              state: ToastStates.success,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgetPasswordCubit>();
          cubit.valueController.text = phoneNumber ?? email ?? '';

          return Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                children: [
                  CustomHeader(
                    showBackButton: true,
                    showLogo: true,
                    onBackPressed: () => Navigator.pop(context),
                    title: '',
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Form(
                        key: cubit.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 32.h),
                            // Profile Image
                            Container(
                              width: 120.w,
                              height: 120.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 2.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60.r),
                                child: Image.network(
                                  imageUrl ?? 'assets/images/logo.png',
                                  width: 120.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    "assets/images/logo.png",
                                    width: 120.w,
                                    height: 120.w,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) => Center(
                                      child: Icon(
                                        CupertinoIcons.person,
                                        size: 50.w,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              '${'welcome_back'.tr(context)} ${firstName ?? ""}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: cubit.passwordController,
                              labelText: 'new_password'.tr(context),
                              hintText: 'enter_new_password'.tr(context),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.password,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                                size: 24.sp,
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value, context),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: cubit.confirmPasswordController,
                              labelText: 'confirm_password'.tr(context),
                              hintText: 'enter_confirm_password'.tr(context),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Icons.password,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                                size: 24.sp,
                              ),
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                value,
                                cubit.passwordController.text,
                                context,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            AppButton(
                              text: 'confirm'.tr(context),
                              isLoading: state is ResetPasswordLoading,
                              onPressed: () {
                                if (cubit.formKey.currentState!.validate() &&
                                    cubit.passwordController.text ==
                                        cubit.confirmPasswordController.text) {
                                  cubit.resetPassword();
                                } else {
                                  showToast(
                                    context,
                                    message: 'Passwords do not match',
                                    state: ToastStates.error,
                                  );
                                }
                              },
                              height: 50.h,
                              width: double.infinity,
                              textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.white,
                                fontWeight: FontWeight.w400,
                              ),
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
        },
      ),
    );
  }
}
