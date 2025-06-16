// embone/features/client/menu/view/inner_screens/friend_requests_page.dart
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/contacts/data/repo/friends_repo.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_cubit.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/friend_request_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendRequestsPage extends StatelessWidget {
  const FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FriendsCubit(sl<FriendsRepo>())..fetchFriendRequests(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<FriendsCubit, FriendsState>(
            listener: (context, state) {
              if (state is FriendRequestUpdated) {
                showToast(context,
                    message: state.message, state: ToastStates.success);
                context.read<FriendsCubit>().fetchFriendRequests();
              } else if (state is FriendsError) {
                showToast(context,
                    message: state.error, state: ToastStates.error);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  // Header
                  AppHeader(
                    title: 'friend_requests_title'.tr(context),
                    centerTitle: true,
                    showBackButton: true,
                  ),

                  // Friend Requests List
                  _buildFriendRequestsList(context, state),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFriendRequestsList(BuildContext context, FriendsState state) {
    final friendsCubit = context.read<FriendsCubit>();
    final requests = friendsCubit.pendingFriendRequests;

    if (state is FriendsLoading) {
      return const Expanded(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (requests.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'no_friend_requests'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          final request = requests[index];
          return FriendRequestItem(
            request: request,
            onAccept: () =>
                friendsCubit.acceptFriendRequest(request.senderId.toString()),
            onDecline: () =>
                friendsCubit.declineFriendRequest(request.senderId.toString()),
          );
        },
      ),
    );
  }
}
