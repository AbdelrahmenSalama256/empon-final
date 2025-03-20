import 'dart:io';

import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/contacts/presentation/pages/invite_contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsPage extends StatelessWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;
  const ContactsPage(
      {super.key,
      required this.profileImage,
      required this.firstName,
      required this.selectedLocation,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
// Header Section
            CustomHeader(
              showBackButton: false,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),

                    // Illustration
                    Image.asset(
                      'assets/images/get_contacts.png',
                      width: 360.w,
                      height: 240.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 24.h),

                    // Question Section
                    QuestionWidget(
                      question: 'enable_contact_upload'.tr(context),
                      subtitle: 'discover_people'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    // Buttons
                    AppButton(
                      text: 'next'.tr(context),
                      // isLoading: _isLoading,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InviteContactsPage(
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
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'skip'.tr(context),
                      // isLoading: _isLoading,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 50.h,
                      type: AppButtonType.text,
                      width: double.infinity,
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
