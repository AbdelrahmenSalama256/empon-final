// embone/features/client/contacts/view/my_friends_page.dart
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/contacts/data/repo/friends_repo.dart';
import 'package:embone/features/client/contacts/view/contact_tree/widgets/follower_list_item.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_cubit.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_state.dart';
import 'package:embone/features/client/contacts/view/invite_contacts_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../chat/view/chat_conversation_screen.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({super.key});

  @override
  State<FollowersPage> createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsCubit(sl<FriendsRepo>())..fetchMyFriends(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<FriendsCubit, FriendsState>(
            listener: (context, state) {
              if (state is FriendsError) {
                showToast(context,
                    message: state.error, state: ToastStates.error);
              }
              if (state is FriendRequestUpdated) {
                showToast(context,
                    message: state.message, state: ToastStates.success);
                context.read<FriendsCubit>().fetchMyFriends();
              }
            },
            builder: (context, state) {
              // final cubit = context.read<FriendsCubit>();

              return Column(
                children: [
                  _buildHeader(context),
                  _buildFriendsList(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: 'friends'.tr(context),
      centerTitle: true,
      showBackButton: true,
      actions: [
        IconButton(
          tooltip: 'add_friends'.tr(context),
          icon: Icon(
            CupertinoIcons.person_add,
            color: AppColors.primary,
            size: 25.sp,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (_) =>
                      RegisterCubit(sl<RegisterRepo>())..fetchContacts(context),
                  child: const InviteContactsPage(),
                ),
              ),
            ).whenComplete(
              () {
                context.read<FriendsCubit>().fetchMyFriends();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFriendsList(BuildContext context, FriendsState state) {
    final friendsCubit = context.read<FriendsCubit>();
    final friends = friendsCubit.acceptedFriends;

    if (state is FriendsLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (friends.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'no_friends'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return FollowerListItem(
            friend: friend,
            onDeletePressed: () {
              context
                  .read<FriendsCubit>()
                  .declineFriendRequest(friend.id.toString());
            },
            onTapPressed: () {
              navigateWithoutNav(
                  context,
                  ChatConversationScreen(
                    receiverId: friend.id,
                    image: friend.image,
                    name: friend.name,
                  ));
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
      ),
    );
  }
}
