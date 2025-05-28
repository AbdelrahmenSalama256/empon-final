// embone/features/client/menu/view/inner_screens/widgets/friend_request_item.dart
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/data/model/friends_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FriendRequestItem extends StatelessWidget {
  final FriendRequest request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestItem({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24.r,
                backgroundImage: request.image != null
                    ? NetworkImage(request.image!)
                    : const AssetImage('assets/images/profile.png')
                        as ImageProvider,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      request.createdAt,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: onAccept,
                  text: 'accept'.tr(context),
                  height: 40.h,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AppButton(
                  onPressed: onDecline,
                  borderRadius: BorderRadius.circular(8.r),
                  text: 'decline'.tr(context),
                  height: 40.h,
                  type: AppButtonType.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
