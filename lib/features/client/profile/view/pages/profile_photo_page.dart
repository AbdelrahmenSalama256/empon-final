import 'dart:io';

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePhotoPage extends StatelessWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const ProfilePhotoPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    if (cubit.profileImage == null) {
      Navigator.pop(context);
      return const SizedBox.shrink();
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        onPreviousStep();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo_text.png',
                  width: 160.w,
                  height: 45.h,
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Image.file(
                          File(cubit
                              .profileImage!.path), // Convert XFile to File
                          width: 136.w,
                          height: 136.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'profile_welcome_message'.tr(context),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        cubit.firstNameController.text.isNotEmpty
                            ? '${cubit.firstNameController.text} ${cubit.lastNameController.text}'
                            : ''.tr(context),
                        style: TextStyle(
                          fontSize: 14.sp,
                          // color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 48.h),
                      AppButton(
                        text: 'next'.tr(context),
                        onPressed: () {
                          onNextStep();
                          // cubit.register();
                        },
                        height: 50.h,
                        width: double.infinity,
                      ),
                    ],
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
