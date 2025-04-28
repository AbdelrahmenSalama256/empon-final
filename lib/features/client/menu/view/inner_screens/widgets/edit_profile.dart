import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatelessWidget {
  final VoidCallback? onTap; // New parameter for click event

  const EditProfile({
    super.key,
    this.onTap, // Optional onTap callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Use the provided onTap callback
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.person, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                "edit_profile".tr(context),
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Icon(
            Icons.chevron_right,
            size: 24.sp,
          ),
        ],
      ),
    );
  }
}
