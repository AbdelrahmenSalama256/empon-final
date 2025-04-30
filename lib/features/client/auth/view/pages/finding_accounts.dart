import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/otp_verification_page.dart';
import 'package:embone/features/client/auth/view/pages/searching_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FindingAccountsPage extends StatelessWidget {
  final String firstName;
  final String phoneNumber;

  const FindingAccountsPage({
    super.key,
    required this.firstName,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 32.h.h),

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
                        child: Image.asset(
                          "assets/images/profile.png",
                          width: 120.w,
                          height: 120.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              CupertinoIcons.person,
                              size: 50.w,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // User Info - First line with blue text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'you_are_user'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          TextSpan(
                            text: 'you_are_you'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Verification code message
                    Text(
                      "verification_code_message".tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.h),

                    // Phone number with asterisks
                    Text(
                      "130 ******** 9",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32.h.h),

                    // Sign in with password button
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

                    // Bottom buttons row
                    Row(
                      children: [
                        // Continue button
                        Expanded(
                          child: AppButton(
                            text: 'continue'.tr(context),
                            onPressed: () {
                              navigateTo(
                                context,
                                OtpVerificationPage(phoneNumber: phoneNumber),
                              );
                            },
                            type: AppButtonType.primary,
                            height: 50.h,
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),

                        // Try another method button
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
                      ],
                    ),
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
