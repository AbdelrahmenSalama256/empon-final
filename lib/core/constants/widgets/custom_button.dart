import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/text-style.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.text,
    this.width,
    this.color,
    this.borderColor,
    this.textColor = AppColors.white,
    required this.onPressed,
    this.icon,
    this.elevation,
    this.borderRadius,
  });
  final VoidCallback? onPressed;
  final String text;
  final Color? textColor;
  final double? width;
  final double? borderRadius;
  final Color? color;
  final Color? borderColor;
  final double? elevation;
  final Widget? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? AppColors.primaryColor,
        elevation: elevation ?? 0,
        shadowColor: AppColors.lightGrey,
        fixedSize: Size(width ?? MediaQuery.of(context).size.width, 45.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          side: BorderSide(
            color: borderColor ?? AppColors.primaryColor,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: CustomTextStyle.roboto500sized16White.copyWith(
              color: textColor ?? AppColors.backgroundColor,
            ),
          ),
          icon ?? const SizedBox(),
          icon == null ? const SizedBox() : SizedBox(width: 8.w),
        ],
      ),
    );
  }
}
