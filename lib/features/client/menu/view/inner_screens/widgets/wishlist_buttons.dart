// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ActionButtons extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const ActionButtons({
    super.key,
    required this.isFavorite,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: onToggleFavorite != null
          ? Container(
              width: 34.w,
              height: 34.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: BoxDecoration(
                // color: const Color(0xff64B95C),
                border: Border.all(width: 1.w, color: const Color(0xffE6E6E6)),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                "assets/images/svg/heart-active.svg",
                color: Colors.red,
                width: 34.w,
                height: 34.h,
              ),
            )
          : null,
    );
  }
}
