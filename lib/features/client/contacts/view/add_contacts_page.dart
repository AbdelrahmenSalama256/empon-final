import 'dart:io';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/auth/view/pages/email/email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddContactsPage extends StatefulWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;
  const AddContactsPage(
      {super.key,
      required this.profileImage,
      required this.firstName,
      required this.selectedLocation,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.password});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  final List<ContactModel> _contacts = [];

  bool _isLoading = false;

  void _toggleContactSelection(String id) {
    setState(() {
      final index = _contacts.indexWhere((contact) => contact.id == id);
      if (index != -1) {
        _contacts[index] = _contacts[index].copyWith(
          isSelected: !_contacts[index].isSelected,
        );
      }
    });
  }

  void _addContacts() {
    final selectedContacts =
        _contacts.where((contact) => contact.isSelected).toList();
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('select_at_least_one_contact'.tr(context))),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate adding contacts process
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailPage(
            profileImage: widget.profileImage,
            firstName: widget.firstName,
            dateOfBirth: widget.dateOfBirth,
            gender: widget.gender,
            phoneNumber: widget.phoneNumber,
            password: widget.password,
            selectedLocation: widget.selectedLocation,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: EdgeInsets.only(top: 24.h),
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120.w,
                  height: 40.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Title and Subtitle
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'add_contacts_title'.tr(context),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'add_contacts_subtitle'.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contacts List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      title: Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        contact.phone,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () => _toggleContactSelection(contact.id),
                        child: Container(
                          width: 100.w,
                          height: 36.h,
                          decoration: BoxDecoration(
                            color: contact.isSelected
                                ? AppColors.primary
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: contact.isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            contact.isSelected
                                ? 'added'.tr(context)
                                : 'add'.tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: contact.isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _isLoading ? null : _addContacts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24.w,
                            height: 24.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('next'.tr(context)),
                  ),
                  SizedBox(height: 16.h),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: Size(double.infinity, 50.h),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text('back'.tr(context)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
