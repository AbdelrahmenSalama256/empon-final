import 'package:embone/core/app/embone.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/repo/chat_repo.dart';
import 'package:embone/features/client/chat/view/chat_conversation_screen.dart';
import 'package:embone/features/client/chat/view/cubit/chat_cubit.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';
import 'package:embone/features/client/contacts/view/contact_tree/followers_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MassagesScreen extends StatelessWidget {
  const MassagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(sl<ChatRepo>(), 0,
          int.parse(context.read<GlobalCubit>().userId.toString()))
        ..fetchChatContacts(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          final cubit = context.read<ChatCubit>();
          final contacts = state is ChatContactsFiltered
              ? state.filteredContacts
              : cubit.contacts;

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

                  // Search Bar
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AppTextField(
                      controller: cubit.searchController,
                      hintText: 'search'.tr(context),
                      labelText: 'search'.tr(context),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        // ignore: deprecated_member_use
                        color: const Color(0xff8F95AB).withOpacity(0.7),
                        size: 24.sp,
                      ),
                      onChanged: (p0) {
                        cubit.filterContacts(p0);
                      },
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Add Friends Section
                  if (cubit.searchController.text.isEmpty) ...[
                    contacts.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                'add_friends_to_chat'.tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                    SizedBox(height: 8.h),
                  ],

                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        cubit.fetchChatContacts();
                      },
                      child: state is ChatContactLoading
                          ? const Center(child: CircularProgressIndicator())
                          : contacts.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.chat_bubble,
                                        size: 60.sp,
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        'no_friends_to_chat'.tr(context),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: 24.h),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 32.w,
                                          vertical: 12.h,
                                        ),
                                        child: AppButton(
                                          onPressed: () {
                                            navigateTo(
                                                context, const FollowersPage());
                                          },
                                          text:
                                              'add_friends_to_chat'.tr(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: contacts.length,
                                  itemBuilder: (context, index) {
                                    final contact = contacts[index];
                                    return GestureDetector(
                                      onLongPress: () {
                                        cubit.selectContact(contact);
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: _buildContactItem(
                                                context,
                                                contact,
                                                cubit.searchController.text),
                                          ),
                                          AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5.w, vertical: 5.h),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.w),
                                            width: cubit.selectedContact?.id ==
                                                    contact.id
                                                ? 35.w
                                                : 0,
                                            height: cubit.selectedContact?.id ==
                                                    contact.id
                                                ? 35.w
                                                : 0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                              color: AppColors.primary,
                                            ),
                                            child: cubit.selectedContact?.id ==
                                                    contact.id
                                                ? GestureDetector(
                                                    onTap: () {
                                                      cubit.clearChat(
                                                          receiveID:
                                                              contacts[index]
                                                                  .id);
                                                    },
                                                    child: Icon(
                                                      CupertinoIcons.delete,
                                                      size: 20.sp,
                                                      color: AppColors.white,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
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
    BuildContext context,
    ChatContact contact,
    String searchQuery,
  ) {
    final name = contact.fullName;
    List<TextSpan> nameSpans = [];

    if (searchQuery.isNotEmpty) {
      final lowerName = name.toLowerCase();
      final lowerQuery = searchQuery.toLowerCase();
      int index = lowerName.indexOf(lowerQuery);

      if (index >= 0) {
        // Before matched part
        if (index > 0) {
          nameSpans.add(TextSpan(
            text: name.substring(0, index),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ));
        }

        // Matched part (highlighted)
        nameSpans.add(TextSpan(
          text: name.substring(index, index + searchQuery.length),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
            backgroundColor: AppColors.primary.withOpacity(0.1),
          ),
        ));

        // After matched part
        if (index + searchQuery.length < name.length) {
          nameSpans.add(TextSpan(
            text: name.substring(index + searchQuery.length),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ));
        }
      } else {
        nameSpans.add(TextSpan(
          text: name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ));
      }
    } else {
      nameSpans.add(TextSpan(
        text: name,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: context.read<GlobalCubit>().language == "ar"
              ? "Beiruti"
              : "Poppins",
        ),
      ));
    }

    return GestureDetector(
      onTap: () {
        navigatorKey.currentState!.push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                ChatConversationScreen(
              receiverId: contact.id,
              name: contact.name,
              online: contact.isOnline == 1
                  ? "online".tr(context)
                  : "offline".tr(context),
              image: contact.image,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
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
                  PositionedDirectional(
                    start: 0,
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
                  RichText(
                    text: TextSpan(
                      children: nameSpans,
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
      ),
    );
  }
}
