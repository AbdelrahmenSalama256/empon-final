import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyMessageWidget extends StatelessWidget {
  final String? message;
  final String? image;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? width;
  final double? height;

  const EmptyMessageWidget({
    super.key,
    this.message,
    this.image,
    this.textStyle,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != null ? Image.asset("$image") : const SizedBox.shrink(),
          Text(
            message?.tr(context) ?? "no_data_found".tr(context),
            style: textStyle ??
                TextStyle(
                  fontSize: 20.sp,
                  color: AppColors.red,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
