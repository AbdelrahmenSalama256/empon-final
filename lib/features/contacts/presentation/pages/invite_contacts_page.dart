import 'dart:io';

import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/contacts/data/model/contact_model.dart';
import 'package:embone/features/contacts/presentation/pages/add_contacts_page.dart';
import 'package:embone/features/auth/view/pages/email/email_page.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

class InviteContactsPage extends StatefulWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;
  const InviteContactsPage(
      {super.key,
      required this.profileImage,
      required this.firstName,
      required this.selectedLocation,
      required this.dateOfBirth,
      required this.gender,
      required this.phoneNumber,
      required this.password});

  @override
  State<InviteContactsPage> createState() => _InviteContactsPageState();
}

class _InviteContactsPageState extends State<InviteContactsPage> {
  List<ContactModel> _contacts = [];
  bool _isLoading = false;
  bool _isFetchingContacts = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isFetchingContacts = true;
    });

    // Request permission to access contacts
    final permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      try {
        final deviceContacts = await FastContacts.getAllContacts();
        setState(() {
          _contacts = deviceContacts.asMap().entries.map((entry) {
            final contact = entry.value;
            final phone = contact.phones.isNotEmpty
                ? contact.phones.first.number
                : 'no_phone'.tr(context);

            // Get initials for avatar
            final nameParts = contact.displayName?.split(' ') ?? ['?'];
            String initials = '';
            if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
              initials = nameParts[0][0];
              if (nameParts.length > 1 && nameParts[1].isNotEmpty) {
                initials += ' ${nameParts[1][0]}';
              }
            }

            return ContactModel(
              id: entry.key.toString(),
              name: contact.displayName,
              phone: phone,
              isSelected: false,
              initial: initials,
            );
          }).toList();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('failed_to_load_contacts'.tr(context))),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('contacts_permission_denied'.tr(context))),
      );
    }

    setState(() {
      _isFetchingContacts = false;
    });
  }

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

  void _inviteContacts() {
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

    // Simulate invitation process
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

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

  void _sendInvitations() {
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

    // Simulate sending invitations
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

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
    final isRTL = Directionality.of(context) == TextDirection.rtl;

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

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Align(
                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  'invite_contacts_title'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Contacts List
            Expanded(
              child: _isFetchingContacts
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: AppColors.primary))
                  : _contacts.isEmpty
                      ? Center(child: Text('no_contacts_found'.tr(context)))
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            final contact = _contacts[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                                child: Row(
                                  textDirection:
                                      sl<CacheHelper>().getCachedLanguage() ==
                                              'ar'
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 40.w,
                                      height: 40.w,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFF0F2F9),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        contact.initial ??
                                            contact.name.substring(0, 1),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    // Contact Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: sl<CacheHelper>()
                                                    .getCachedLanguage() ==
                                                'ar'
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            contact.name,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textPrimary,
                                            ),
                                            textAlign: sl<CacheHelper>()
                                                        .getCachedLanguage() ==
                                                    'ar'
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            contact.phone,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey,
                                            ),
                                            textAlign: sl<CacheHelper>()
                                                        .getCachedLanguage() ==
                                                    'ar'
                                                ? TextAlign.right
                                                : TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 12.w),

                                    // Add Button
                                    InkWell(
                                      onTap: () =>
                                          _toggleContactSelection(contact.id),
                                      child: Container(
                                        width: 80.w,
                                        height: 36.h,
                                        decoration: BoxDecoration(
                                          color: contact.isSelected
                                              ? AppColors.green
                                              : AppColors.primary,
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              contact.isSelected
                                                  ? CupertinoIcons
                                                      .person_crop_circle_fill_badge_checkmark
                                                  : CupertinoIcons
                                                      .person_add_solid,
                                              color: Colors.white,
                                              size: 20.w,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              contact.isSelected
                                                  ? 'added'.tr(context)
                                                  : 'add'.tr(context),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),

            // Send Invitation Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Row(
                    children: [
                      Text(
                        'send_invite'.tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(width: 16.w),
                      // Send the Invitation Button
                      const Spacer(),
                      AppButton(
                        text: 'send'.tr(context),
                        onPressed: _sendInvitations,
                        isLoading: _isLoading,
                        isFullWidth: false,
                        width: 100.w,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        height: 28.h,
                        borderRadius: BorderRadius.circular(8.r),
                        suffixIcon: Icon(
                          CupertinoIcons.person_2_fill,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  SizedBox(height: 16.h),

                  // Done Button (large blue button)
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _inviteContacts,
                        borderRadius: BorderRadius.circular(12.r),
                        child: Center(
                          child: Text(
                            'done'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
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
