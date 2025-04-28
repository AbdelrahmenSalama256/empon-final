import 'dart:io';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/view/contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfilePhotoPage extends StatelessWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;

  const ProfilePhotoPage({
    super.key,
    required this.profileImage,
    required this.firstName,
    required this.dateOfBirth,
    required this.selectedLocation,
    required this.gender,
    required this.phoneNumber,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            // SizedBox(height: 100.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Image.file(
                        profileImage,
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
                      firstName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 48.h),
                    AppButton(
                      text: 'next'.tr(context),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPage(
                              profileImage: profileImage,
                              firstName: firstName,
                              dateOfBirth: dateOfBirth,
                              gender: gender,
                              phoneNumber: phoneNumber,
                              password: password,
                              selectedLocation: selectedLocation,
                            ),
                          ),
                        );
                      },
                      height: 50.h,
                      width: double.infinity,
                    ),
                    // SizedBox(height: 16.h),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Text(
                    //     'back'.tr(context),
                    //     style: TextStyle(
                    //       fontSize: 16.sp,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
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
