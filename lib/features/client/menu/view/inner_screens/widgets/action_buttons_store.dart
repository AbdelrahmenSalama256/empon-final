// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Check the text direction of the current locale
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.w,
      ), // Reduced spacing between buttons
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xFF155A9F),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: isRTL
                ? [
                    // RTL Layout: Text first, then icon
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 5.w),
                    SvgPicture.asset(
                      icon,
                      color: Colors.white,
                      width: 15.w,
                      height: 15.h,
                    ),
                  ]
                : [
                    // LTR Layout: Icon first, then text
                    SvgPicture.asset(
                      icon,
                      color: Colors.white,
                      width: 15.w,
                      height: 15.h,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
