import 'dart:io';

import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/auth/view/pages/email/email_page.dart';
import 'package:embone/features/client/contacts/view/widgets/contact_item.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'widgets/invitation_footer.dart';

class InviteContactsPage extends StatefulWidget {
  final File profileImage;
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;

  const InviteContactsPage({
    super.key,
    required this.profileImage,
    required this.firstName,
    required this.selectedLocation,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.password,
  });

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
    setState(() => _isFetchingContacts = true);

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

            final nameParts = contact.displayName.split(' ');
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
        if (!mounted) return;

        _showSnackBar('failed_to_load_contacts'.tr(context));
      }
    } else {
      if (!mounted) return;

      _showSnackBar('contacts_permission_denied'.tr(context));
    }

    setState(() => _isFetchingContacts = false);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
      _showSnackBar('select_at_least_one_contact'.tr(context));
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      _navigateToEmailPage();
    });
  }

  void _sendInvitations() {
    final selectedContacts =
        _contacts.where((contact) => contact.isSelected).toList();
    if (selectedContacts.isEmpty) {
      _showSnackBar('select_at_least_one_contact'.tr(context));
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      _navigateToEmailPage();
    });
  }

  void _navigateToEmailPage() {
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
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

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
            _buildTitle(isRTL),

            // Contacts List
            _buildContactsList(),

            // Footer with buttons
            InvitationFooter(
              isLoading: _isLoading,
              onSendPressed: _sendInvitations,
              onDonePressed: _inviteContacts,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isRTL) {
    return Padding(
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
    );
  }

  Widget _buildContactsList() {
    return Expanded(
      child: _isFetchingContacts
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _contacts.isEmpty
              ? Center(child: Text('no_contacts_found'.tr(context)))
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return ContactListItem(
                      contact: contact,
                      onTap: () => _toggleContactSelection(contact.id),
                    );
                  },
                ),
    );
  }
}
