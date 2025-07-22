import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItemList extends StatelessWidget {
  final String title;
  final String content;
  final String time;
  final String type;
  final bool isRead;
  final VoidCallback? onTap;
  const NotificationItemList({
    super.key,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
    this.isRead = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        debugPrint('Notification item tapped');
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : Colors.grey.withOpacity(0.05),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: _buildNotificationIcon(type)),
            SizedBox(width: 12.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xff7C7C7C),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            // Time
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(String type) {
    // First remove all escaping backslashes, then compare
    final cleanType = type.replaceAll(r'\', '');
    debugPrint('Clean type: $cleanType');
    switch (cleanType) {
      case 'AppModelsAccountTrue':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.check_circle,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
        );
      case 'AppModelsAccountFalse':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.error_outline,
              color: AppColors.red,
              size: 24.w,
            ),
          ),
        );
      case 'AppModelsProduct':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.shopping_bag,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
        );
      case 'AppModelsService':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.build,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
        );
      case 'AppModelsProductorder':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.local_shipping,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
        );
      case 'account_verification':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.verified_user,
              color: AppColors.green,
              size: 24.w,
            ),
          ),
        );
      case 'rejected':
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.cancel,
              color: AppColors.red,
              size: 24.w,
            ),
          ),
        );
      default:
        return SizedBox(
          width: 40.w,
          height: 40.w,
          child: Center(
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 24.w,
            ),
          ),
        );
    }
  }
}
