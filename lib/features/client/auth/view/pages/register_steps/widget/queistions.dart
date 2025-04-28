import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final String? subtitle;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry padding;

  const QuestionWidget({
    super.key,
    required this.question,
    this.subtitle,
    this.textAlign,
    this.padding = const EdgeInsets.only(bottom: 16.0),
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";
    final defaultTextAlign = isRTL ? TextAlign.right : TextAlign.left;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: textAlign ?? defaultTextAlign,
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.normal,
              ),
              textAlign: textAlign ?? defaultTextAlign,
            ),
          ],
        ],
      ),
    );
  }
}
