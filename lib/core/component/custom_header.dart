import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
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
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Container(
      height: height ?? 56.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(context,
              isRTL ? CupertinoIcons.arrow_right : CupertinoIcons.arrow_left),
          // Center content (logo or title)
          showLogo
              ? Container(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/images/logo_text.png',
                    height: 32.h,
                    width: 118.w,
                    fit: BoxFit.contain,
                  ),
                )
              : title != null
                  ? Text(
                      title!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : const SizedBox(),

          // if (isRTL)
          //   if (showBackButton)
          //     _buildBackButton(context, CupertinoIcons.arrow_right)
          //   else
          //     SizedBox(width: 40.w)
          // else
          //   trailing ?? SizedBox(width: 0.w),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, IconData icon) {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: const Color(0xffF0F2F9),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: GestureDetector(
        onTap: onBackPressed ?? () => Navigator.pop(context),
        child: Icon(
          icon,
          color: const Color(0xff152354),
          size: 24.w,
        ),
      ),
    );
  }
}
