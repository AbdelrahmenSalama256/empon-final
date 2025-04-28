import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FollowerListItem extends StatelessWidget {
  final String id;
  final String name;
  final String avatar;
  final bool isVerified;
  final bool isFollowing;
  final VoidCallback onFollowPressed;

  const FollowerListItem({
    super.key,
    required this.id,
    required this.name,
    required this.avatar,
    required this.isVerified,
    required this.isFollowing,
    required this.onFollowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          SizedBox(width: 12.w),

          // Name and verification
          Expanded(
            child: _buildUserInfo(context),
          ),

          // Follow/Unfollow button
          _buildFollowButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24.r,
      backgroundImage: AssetImage(avatar),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: Directionality.of(context) == TextDirection.rtl
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            if (Directionality.of(context) == TextDirection.ltr) ...[
              Text(
                'follower_text'.tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
                ),
              ),
              if (isVerified) SizedBox(width: 4.w),
              if (isVerified)
                Icon(
                  CupertinoIcons.location_solid,
                  size: 14.sp,
                  color: const Color(0xff909090),
                ),
            ] else ...[
              if (isVerified)
                Icon(
                  CupertinoIcons.location_solid,
                  size: 14.sp,
                  color: const Color(0xff909090),
                ),
              if (isVerified) SizedBox(width: 4.w),
              Text(
                'follower_text'.tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff909090),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    return SizedBox(
      width: 120.w,
      child: AppButton(
        height: 28.h,
        borderRadius: BorderRadius.circular(8.r),
        onPressed: onFollowPressed,
        text: isFollowing
            ? 'unfollow_button'.tr(context)
            : 'follow_button'.tr(context),
        textStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        prefixIcon: isFollowing
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  "assets/images/svg/like.svg",
                  width: 16.sp,
                  // ignore: deprecated_member_use
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}
