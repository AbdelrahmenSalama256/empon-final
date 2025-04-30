import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/verification_screen.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnotherEmailPage extends StatelessWidget {
  const AnotherEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
        if (state is RegisterSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const VerificationPage(),
            ),
            (route) => false,
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: false,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'register'.tr(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                            isLoading:
                                state is RegisterLoading == true ? true : false,
                            onPressed: cubit.anotherEmailController.text !=
                                    cubit.emailController.text
                                ? () {
                                    cubit.register();
                                  }
                                : null,
                            height: 50.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
