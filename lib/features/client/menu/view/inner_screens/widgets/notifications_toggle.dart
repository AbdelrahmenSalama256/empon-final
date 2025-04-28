// ignore_for_file: deprecated_member_use

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotificationsToggle extends StatefulWidget {
  const NotificationsToggle({super.key});

  @override
  State<NotificationsToggle> createState() => _NotificationsToggleState();
}

class _NotificationsToggleState extends State<NotificationsToggle> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              "assets/images/svg/notification.svg",
              width: 24.w,
              color: Colors.black,
              height: 24.h,
            ),
            SizedBox(width: 12.w),
            Text(
              "notifications".tr(context),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        CupertinoSwitch(
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
          activeTrackColor: AppColors.primary,
        ),
      ],
    );
  }
}
