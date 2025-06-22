import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:embone/features/client/auth/view/pages/forget_password_verification.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:embone/features/client/auth/view/pages/searching_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindingAccountsPage extends StatelessWidget {
  final String? phoneNumber;
  final String? firstName;
  final String? imageUrl;
  final String? email;

  const FindingAccountsPage({
    super.key,
    this.phoneNumber,
    this.firstName,
    this.imageUrl,
    this.email,
  });

  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 4) return phoneNumber;
    return "${phoneNumber.substring(0, 3)} ******* ${phoneNumber.substring(phoneNumber.length - 1)}";
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

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
                // Added SingleChildScrollView
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
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
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(
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
                      SizedBox(height: 24.h),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'you_are_user'.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: isRTL ? 'Beiruti' : "Poppins",
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextSpan(
                              text: firstName?.isNotEmpty == true
                                  ? firstName!
                                  : 'you_are_you'.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontFamily: isRTL ? 'Beiruti' : "Poppins",
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "verification_code_message".tr(context),
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 4.h),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              phoneNumber?.isNotEmpty == true
                                  ? _maskPhoneNumber(phoneNumber!)
                                  : email?.isNotEmpty == true
                                      ? email!
                                      : "masked_phone_number".tr(context),
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff7C7C7C),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      AppButton(
                        text: 'sign_in_with_password'.tr(context),
                        onPressed: () {
                          navigateReplac(context, const LoginPage());
                        },
                        type: AppButtonType.primary,
                        height: 50.h,
                        textStyle: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'try_another_method'.tr(context),
                              onPressed: () {
                                navigateReplac(
                                  context,
                                  const SearchingAccountPage(),
                                );
                              },
                              type: AppButtonType.secondary,
                              height: 50.h,
                              textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: BlocProvider(
                              create: (context) =>
                                  ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
                              child: BlocConsumer<ForgetPasswordCubit,
                                  ForgetPasswordState>(
                                listener: (context, state) {
                                  if (state is ForgotPasswordFailure) {
                                    showToast(
                                      context,
                                      message: state.message,
                                      state: ToastStates.error,
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return AppButton(
                                    text: 'continue'.tr(context),
                                    isLoading: state is ForgotPasswordLoading,
                                    onPressed: () {
                                      final value =
                                          phoneNumber?.isNotEmpty == true
                                              ? phoneNumber!
                                              : email?.isNotEmpty == true
                                                  ? email!
                                                  : '';
                                      if (value.isEmpty) {
                                        showToast(
                                          context,
                                          message: 'phone_or_email_required'
                                              .tr(context),
                                          state: ToastStates.error,
                                        );
                                        return;
                                      }
                                      context
                                          .read<ForgetPasswordCubit>()
                                          .valueController
                                          .text = value;
                                      context
                                          .read<ForgetPasswordCubit>()
                                          .forgotPassword();
                                      navigateTo(
                                        context,
                                        ForgotPasswordVerificationPage(
                                          email: email?.isNotEmpty == true
                                              ? email!
                                              : '',
                                          firstName:
                                              firstName?.isNotEmpty == true
                                                  ? firstName!
                                                  : '',
                                          phoneNumber:
                                              phoneNumber?.isNotEmpty == true
                                                  ? phoneNumber!
                                                  : '',
                                          imageUrl: imageUrl?.isNotEmpty == true
                                              ? imageUrl!
                                              : '',
                                        ),
                                      );
                                    },
                                    type: AppButtonType.primary,
                                    height: 50.h,
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h), // Add padding at the bottom
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
