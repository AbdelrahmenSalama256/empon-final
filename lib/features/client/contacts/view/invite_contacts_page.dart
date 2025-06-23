import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/contacts/data/repo/friends_repo.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_cubit.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_state.dart';
import 'package:embone/features/client/contacts/view/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class InviteContactsPage extends StatelessWidget {
  const InviteContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return BlocProvider(
      create: (context) => RegisterCubit(sl<RegisterRepo>())..data(context),
      child: BlocProvider(
        create: (context) => FriendsCubit(sl<FriendsRepo>()),
        child: BlocConsumer<FriendsCubit, FriendsState>(
          listener: (context, friendsState) {
            if (friendsState is FriendRequestUpdated) {
              showToast(context,
                  message: friendsState.message, state: ToastStates.success);
            } else if (friendsState is FriendsError) {
              showToast(context,
                  message: friendsState.error, state: ToastStates.error);
            }
          },
          builder: (context, friendsState) {
            return BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is ContactsError) {
                  showToast(context,
                      message: state.message, state: ToastStates.error);
                } else if (state is CheckingContactsError) {
                  showToast(context,
                      message: state.message, state: ToastStates.error);
                } else if (state is ContactsChecked) {
                  context.read<FriendsCubit>().initializeContacts(
                        state.registeredUsers,
                        state.nonRegisteredContacts,
                      );
                }
              },
              builder: (context, state) {
                final friendsCubit = context.read<FriendsCubit>();

                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: Column(
                      children: [
                        CustomHeader(
                          showBackButton: false,
                          showLogo: true,
                          onBackPressed: () => Navigator.pop(context),
                          title: 'register'.tr(context),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 16.h),
                          child: Align(
                            alignment: isRTL
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
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
                        Expanded(
                          child: state is LoadingContacts
                              ? const Center(child: CircularProgressIndicator())
                              : friendsCubit.registeredUsers.isEmpty &&
                                      friendsCubit.nonRegisteredContacts.isEmpty
                                  ? Center(
                                      child: Text(
                                          'no_matching_contacts'.tr(context)))
                                  : SingleChildScrollView(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (friendsCubit
                                              .registeredUsers.isNotEmpty) ...[
                                            Text(
                                              'already_on_app'.tr(context),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: friendsCubit
                                                  .registeredUsers.length,
                                              itemBuilder: (context, index) {
                                                final user = friendsCubit
                                                    .registeredUsers[index];
                                                final requestStatus =
                                                    friendsCubit
                                                        .getFriendRequestStatus(
                                                            user.id.toString());
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  child: ContactListItem(
                                                    contact: ContactModel(
                                                      id: user.id.toString(),
                                                      name: user.name ?? "",
                                                      phone: user.phone ?? '',
                                                      isSelected:
                                                          requestStatus ==
                                                              "pending",
                                                      status: user.status,
                                                      initial:
                                                          user.firstName ?? '',
                                                      isFriend: user.isFriend ??
                                                          false,
                                                    ),
                                                    onTap: () {
                                                      if (!friendsCubit
                                                              .isClosed &&
                                                          context.mounted) {
                                                        friendsCubit
                                                            .toggleFriendRequest(
                                                          user.id.toString(),
                                                        );
                                                      }
                                                    },
                                                    isRegistered: true,
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(height: 24.h),
                                          ],
                                          if (friendsCubit.nonRegisteredContacts
                                              .isNotEmpty) ...[
                                            Text(
                                              'invite_to_app'.tr(context),
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            ListView.builder(
                                              controller:
                                                  friendsCubit.scrollController,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: friendsCubit
                                                      .nonRegisteredContacts
                                                      .length +
                                                  (friendsState
                                                          is FriendsLoadingMore
                                                      ? 1
                                                      : 0),
                                              itemBuilder: (context, index) {
                                                if (friendsState
                                                        is FriendsLoadingMore &&
                                                    index ==
                                                        friendsCubit
                                                            .nonRegisteredContacts
                                                            .length) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                                final contact = friendsCubit
                                                        .nonRegisteredContacts[
                                                    index];
                                                if (contact.phone.isEmpty ||
                                                    contact.phone.contains(
                                                        RegExp(r'[^\d+]'))) {
                                                  return const SizedBox
                                                      .shrink();
                                                }
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  child: ContactListItem(
                                                    contact: contact,
                                                    onTap: () async {
                                                      if (!friendsCubit
                                                              .isClosed &&
                                                          context.mounted) {
                                                        const appLink =
                                                            'https://your-app-link.com';
                                                        await Share.share(
                                                          'Check out this awesome app! Download it here: $appLink',
                                                          subject:
                                                              'Invite to My App',
                                                        );
                                                        showToast(context,
                                                            message:
                                                                'App link shared!',
                                                            state: ToastStates
                                                                .success);
                                                      }
                                                    },
                                                    isRegistered: false,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
