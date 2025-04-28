import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuItem extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap; // New parameter for click event

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.onTap, // Optional onTap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Call the onTap callback when tapped
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 16.h,
            // horizontal: 16.w,
            horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(
                  icon,
                  width: 24.w,
                  height: 24.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 24.w,
                      height: 24.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(
                          5.r,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: 12.w),
                Text(
                  title.tr(context),
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
