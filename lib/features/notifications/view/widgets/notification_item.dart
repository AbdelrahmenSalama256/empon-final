import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String content;
  final String time;
  final String type;
  final bool isRead;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationItem({
    super.key,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
    this.isRead = false,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('notification_${title}_${time}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 24.w,
        ),
      ),
      onDismissed: (direction) {
        onDismiss();
      },
      child: InkWell(
        onTap: onTap,
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
              _buildNotificationIcon(),
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
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Description
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                        height: 1.3,
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
      ),
    );
  }

  Widget _buildNotificationIcon() {
    switch (type) {
      case 'gift':
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFEEAE6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Icon(
              Icons.card_giftcard,
              color: const Color(0xFFFF5252),
              size: 24.w,
            ),
          ),
        );
      case 'discount':
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFFEEAE6),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Icon(
              Icons.percent,
              color: const Color(0xFFFF5252),
              size: 24.w,
            ),
          ),
        );
      case 'order':
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Icon(
              Icons.shopping_bag_outlined,
              color: const Color(0xFF2196F3),
              size: 24.w,
            ),
          ),
        );
      default:
        return Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Icon(
              Icons.notifications_outlined,
              color: const Color(0xFF4CAF50),
              size: 24.w,
            ),
          ),
        );
    }
  }
}
