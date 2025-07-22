// embone/features/client/contacts/view/contact_tree/widgets/follower_list_item.dart
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/data/model/friends_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowerListItem extends StatelessWidget {
  final Friend friend;
  final VoidCallback onDeletePressed;
  final VoidCallback onTapPressed;

  const FollowerListItem({
    super.key,
    required this.friend,
    required this.onTapPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildAvatar(),
                  SizedBox(width: 12.w),
                  Flexible(child: _buildUserInfo(context)),
                ],
              ),
            ),
            _buildDeleteButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return friend.image != null
        ? CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(friend.image!),
          )
        : CircleAvatar(
            radius: 24.r,
            child: Icon(
              CupertinoIcons.person,
              color: AppColors.primary,
              size: 25.sp,
            ),
          );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                "${friend.name}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Uncomment and adjust if online status is needed
            // if (friend.isOnline == 1)
            //   Icon(
            //     Icons.verified,
            //     size: 16.sp,
            //     color: Colors.blue,
            //   ),
          ],
        ),
        if (friend.lastSeen != null)
          Text(
            friend.lastSeen!,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    final double buttonWidth = 100.w;

    return SizedBox(
      width: buttonWidth,
      child: AppButton(
        onPressed: onDeletePressed,
        text: 'delete'.tr(context),
        height: 32.h,
        // width: 100.w,
        borderRadius: BorderRadius.circular(8.r),
        type: AppButtonType.primary,
      ),
    );
  }
}
