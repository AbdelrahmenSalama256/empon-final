import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/login_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/otp_verification_page.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordProfileScreen extends StatelessWidget {
  const ChangePasswordProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocBuilder<GlobalCubit, GlobalState>(
        builder: (context, state) {
          final cubit = context.read<GlobalCubit>();

          return BlocListener<GlobalCubit, GlobalState>(
            listener: (context, state) {
              if (state is ProfileUpdated) {
                showToast(context,
                    message: "password_changed_successfully".tr(context),
                    state: ToastStates.success);
                Navigator.pop(context);
                navigateTo(
                    context,
                    BlocProvider(
                      create: (context) => LoginCubit(sl<LoginRepo>()),
                      child: OtpVerificationPage(
                        type: "profile",
                        phoneNumber: cubit.userPhone ?? "",
                      ),
                    ));
              }
              if (state is ProfileError) {
                showToast(context,
                    message: state.message, state: ToastStates.success);
              }
            },
            child: SafeArea(
              child: Column(
                children: [
                  //! Header Section
                  AppHeader(
                    title: 'edit_password'.tr(context),
                    showBackButton: true,
                    centerTitle: true,
                    style: HeaderStyle.standard,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 16.h),
                      child: Form(
                        key: cubit.formkey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //! Step Indicator Section
                            // const AppStepIndicator(
                            //   currentStep: 6,
                            //   totalSteps: 8,
                            // ),
                            SizedBox(height: 16.h),

                            //! Profile Image
                            Center(
                              child: ProfileSection(
                                userName:
                                    "${cubit.firstNameController.text} ${cubit.lastNameController.text}"
                                        .trim(),
                                userImageUrl: cubit.userAvatar ??
                                    'assets/images/logo.png',
                                subtitle: '',
                                isVendor: false,
                                onTap: () {
                                  // Handle tap action if needed (e.g., show dialog or navigate)
                                  // For now, this is a placeholder
                                },
                                // profileImage: cubit
                                //     .profileImage, // Pass XFile? instead of File?
                              ),
                            ),

                            SizedBox(height: 16.h),
                            Text(
                              "edit_password".tr(context),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff8F95AB),
                              ),
                              // textAlign: TextAlign.,
                            ),
                            SizedBox(height: 10.h),

                            //! Old Password Section
                            AppTextField(
                              controller: cubit.oldPasswordController,
                              labelText: 'old_password'.tr(context),
                              hintText: 'enter_old_password'.tr(context),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                                size: 24.w,
                              ),
                              validator: (value) => Validators.validateRequired(
                                  value, 'old_password'.tr(context), context),
                            ),
                            SizedBox(height: 16.h),

                            //! Password Input Section
                            AppTextField(
                              controller: cubit.newPasswordController,
                              labelText: 'password'.tr(context),
                              hintText: 'enter_password'.tr(context),
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                                size: 24.w,
                              ),
                              validator: (value) =>
                                  Validators.validatePassword(value, context),
                            ),
                            SizedBox(height: 16.h),

                            //! Confirm Password Input Section
                            AppTextField(
                              controller: cubit.confrimNewPasswordController,
                              labelText: 'confirm_password'.tr(context),
                              hintText: 'enter_password'.tr(context),
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              prefixIcon: Icon(
                                Icons.password_outlined,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                                size: 24.w,
                              ),
                              validator: (value) =>
                                  Validators.validateConfirmPassword(
                                value,
                                cubit.newPasswordController.text,
                                context,
                              ),
                            ),
                            SizedBox(height: 32.h.h),

                            //! Button Section
                            BlocProvider(
                              create: (context) =>
                                  RegisterCubit(sl<RegisterRepo>()),
                              child: BlocBuilder<RegisterCubit, RegisterState>(
                                builder: (context, state) {
                                  return AppButton(
                                    text: 'next'.tr(context),
                                    isLoading: state is ProfileLoading,
                                    onPressed: () {
                                      if (cubit.formkey.currentState
                                              ?.validate() ==
                                          false) {
                                        showToast(context,
                                            message: "please_fill_all_fields",
                                            state: ToastStates.error);
                                      }
                                      cubit.updatePasswordProfile();
                                      context.read<RegisterCubit>().resendOtp(
                                            phone: cubit.userPhone ?? "",
                                          );
                                    },
                                    height: 50.h,
                                    width: double.infinity,
                                  );
                                },
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
