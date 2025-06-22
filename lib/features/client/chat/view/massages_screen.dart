// embone/features/client/chat/view/massages_screen.dart
import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_conversation_screen.dart';

class MassagesScreen extends StatelessWidget {
  const MassagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return BlocProvider(
      create: (context) => ChatCubit(sl<ChatRepo>(), 0,
          int.parse(context.read<GlobalCubit>().userId.toString()))
        ..fetchChatContacts(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
          final contacts = cubit.contacts;

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
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Align(
                      alignment:
                          isRTL ? Alignment.centerRight : Alignment.centerLeft,
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
                    child: state is ChatContactLoading
                        ? const Center(child: CircularProgressIndicator())
                        : contacts.isEmpty
                            ? Center(child: Text('no_friends'.tr(context)))
                            : ListView.builder(
                                itemCount: contacts.length,
                                itemBuilder: (context, index) {
                                  final contact = contacts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      navigatorKey.currentState!.push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                              ChatConversationScreen(
                                            receiverId: contact.id,
                                            name: contact.name,
                                            online: contact.isOnline == 1
                                                ? "online".tr(context)
                                                : "offline".tr(context),
                                            image: contact.image,
                                          ),
                                          transitionsBuilder: (context,
                                              animation,
                                              secondaryAnimation,
                                              child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 300),
                                        ),
                                      );
                                    },
                                    child: _buildContactItem(
                                        context, contact, isRTL),
                                  );
                                },
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

  Widget _buildContactItem(
      BuildContext context, ChatContact contact, bool isRTL) {
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
              contact.image != null
                  ? CircleAvatar(
                      radius: 24.r,
                      backgroundImage: NetworkImage(contact.image!),
                    )
                  : Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: const BoxDecoration(
                        color: AppColors.lightGrey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 30.sp,
                      ),
                    ),
              if (contact.isOnline == 1)
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
                  contact.fullName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  contact.isOnline == 1
                      ? "online".tr(context)
                      : "offline".tr(context),
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Last Seen
          if (contact.lastSeen != null)
            Text(
              contact.lastSeen!.split(' ')[1],
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}
