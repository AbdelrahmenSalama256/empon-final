import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSection extends StatelessWidget {
  final String userName;
  final bool isVendor;
  final bool isAddNew;
  final String userImageUrl;
  final String? subtitle;
  final double avatarRadius;
  final double spacing;
  final TextStyle? textStyle;
  final TextStyle? subtitleStyle;

  final Color? borderColor;
  final VoidCallback? onTap;
  final Widget? customIcon;

  const ProfileSection({
    super.key,
    required this.userName,
    this.isVendor = false,
    this.isAddNew = false,
    required this.userImageUrl,
    this.subtitle,
    this.avatarRadius = 30,
    this.spacing = 8,
    this.textStyle,
    this.subtitleStyle,
    this.borderColor,
    this.onTap,
    this.customIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isVendor != true
          ? Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.textPrimary,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      userImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/placholder.jpg',
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  userName,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Avatar
                _buildAvatar(),

                SizedBox(height: spacing.h),

                // Name
                SizedBox(
                  width: 90.w, // Fixed width for consistent layout
                  child: Text(
                    userName,
                    style: textStyle ??
                        TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff152354),
                        ),
                    textAlign: TextAlign.center,
                    // maxLines: 1,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Subtitle (account type)
                if (subtitle != null) ...[
                  SizedBox(height: 2.h),
                  SizedBox(
                    width: 90.w, // Fixed width for consistent layout
                    child: Text(
                      subtitle!,
                      style: subtitleStyle ??
                          TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff152354),
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildAvatar() {
    if (isAddNew) {
      return Container(
        width: (avatarRadius * 2).w,
        height: (avatarRadius * 2).w,
        decoration: BoxDecoration(
          color: const Color(0xffF6F6F6),
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 2.w)
              : null,
        ),
        child: customIcon ??
            Icon(
              CupertinoIcons.add_circled,
              color: AppColors.primary,
              size: avatarRadius.sp,
            ),
      );
    }

    if (userImageUrl.isEmpty) {
      // Empty image URL - show placeholder
      return Container(
        width: (avatarRadius * 2).w,
        height: (avatarRadius * 2).w,
        decoration: BoxDecoration(
          color: isVendor ? Colors.black : Colors.grey.shade200,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 2.w)
              : null,
        ),
        child: Icon(
          isVendor ? Icons.store : Icons.person,
          color: isVendor ? Colors.white : Colors.grey,
          size: avatarRadius.sp,
        ),
      );
    }

    // Has image URL
    return Container(
      width: (avatarRadius * 2).w,
      height: (avatarRadius * 2).w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 2.w)
            : null,
        image: DecorationImage(
          image: userImageUrl.startsWith('http')
              ? NetworkImage(userImageUrl)
              : AssetImage(userImageUrl) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
