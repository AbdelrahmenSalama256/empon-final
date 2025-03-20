import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHeader extends StatelessWidget {
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final Widget? trailing;
  final String? title;
  final bool showDivider;
  final bool showLogo;
  final double? height;

  const CustomHeader({
    super.key,
    this.onBackPressed,
    this.showBackButton = true,
    this.trailing,
    this.title,
    this.showDivider = true,
    this.showLogo = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: height ?? 56.h, // Responsive height
      decoration: const BoxDecoration(
        color: Colors.white,
        // border: showDivider
        //     ? const Border(
        //         bottom: BorderSide(
        //           color: Color(0xFFEEEEEE),
        //           width: 1,
        //         ),
        //       )
        //     : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w), // Responsive padding
      child: Row(
        mainAxisAlignment:
            isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // In LTR: Back button first, then logo/title
          // In RTL: Trailing first (if any), then logo/title, then back button
          if (!isRTL) ...[
            // Back button in LTR
            if (showBackButton)
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF0F2F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.arrow_left,
                    color: const Color(0xff152354),
                    size: 24.w,
                  ),
                ),
              )
            else
              SizedBox(width: 24.w), // Placeholder

            SizedBox(width: 8.w), // Space between back button and logo
            const Spacer(),
            if (showLogo)
              Image.asset(
                'assets/images/logo_text.png',
                height: 32.h,
                width: 118.w,
                fit: BoxFit.contain,
              )
            else if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

            // const Spacer(), // Push trailing to the right

            // Trailing in LTR
            if (trailing != null) trailing! else const SizedBox.shrink(),
          ] else ...[
            // Trailing in RTL
            if (trailing != null) trailing! else const SizedBox.shrink(),

            const Spacer(), // Push logo/title and back button to the right

            // Logo or title in RTL
            if (showLogo)
              Image.asset(
                'assets/images/logo_text.png',
                height: 32.h,
                width: 118.w,
                fit: BoxFit.contain,
              )
            else if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),

            SizedBox(width: 8.w), // Space between logo and back button

            // Back button in RTL
            if (showBackButton)
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF0F2F9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: GestureDetector(
                  onTap: onBackPressed ?? () => Navigator.pop(context),
                  child: Icon(
                    CupertinoIcons.arrow_right,
                    color: const Color(0xff152354),
                    size: 24.w,
                  ),
                ),
              )
            else
              SizedBox(width: 24.w), // Placeholder
          ],
        ],
      ),
    );
  }
}
