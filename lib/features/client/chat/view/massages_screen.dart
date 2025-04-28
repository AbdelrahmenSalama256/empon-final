import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/chat/view/chat_conversation_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MassagesScreen extends StatelessWidget {
  const MassagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    // Sample contacts data
    final List<Map<String, dynamic>> contacts = [
      {
        'name': 'Mariam Mohamed',
        'image': 'https://randomuser.me/api/portraits/women/44.jpg',
        'status': 'offline'.tr(context),
        'isOnline': false,
        'lastSeen': null,
      },
      {
        'name': 'Amr Mohamed',
        'image': 'https://randomuser.me/api/portraits/men/32.jpg',
        'status': 'online'.tr(context),
        'isOnline': true,
        'lastSeen': null,
      },
      {
        'name': 'Amr Mohamed',
        'image': 'https://randomuser.me/api/portraits/men/33.jpg',
        'status': 'offline'.tr(context),
        'isOnline': false,
        'lastSeen': null,
      },
      {
        'name': 'Amr Mohamed',
        'image': 'https://randomuser.me/api/portraits/men/34.jpg',
        'status': 'offline'.tr(context),
        'isOnline': false,
        'lastSeen': '3 m',
      },
      {
        'name': 'Amr Mohamed',
        'image': 'https://randomuser.me/api/portraits/men/35.jpg',
        'status': 'offline'.tr(context),
        'isOnline': false,
        'lastSeen': '3 m',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'chat'.tr(context),
              centerTitle: true,
              showBackButton: true,
            ),
            // Add Friends Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Align(
                alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  'add_friends_to_chat'.tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppTextField(
                controller: TextEditingController(),
                hintText: 'search'.tr(context),
                labelText: 'search'.tr(context),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  // ignore: deprecated_member_use
                  color: const Color(0xff8F95AB).withOpacity(0.7),
                  size: 24.sp,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Contacts List
            Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return GestureDetector(
                    onTap: () {
                      navigateTo(context, const ChatConversationScreen());
                    },
                    child: _buildContactItem(contact, isRTL),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(Map<String, dynamic> contact, bool isRTL) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Picture with Online Indicator
          Stack(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(contact['image']),
              ),
              if (contact['isOnline'])
                Positioned(
                  right: isRTL ? null : 0,
                  left: isRTL ? 0 : null,
                  bottom: 0,
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: 16.w),

          // Contact Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  contact['status'],
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Last Seen
          if (contact['lastSeen'] != null)
            Text(
              contact['lastSeen'],
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}
