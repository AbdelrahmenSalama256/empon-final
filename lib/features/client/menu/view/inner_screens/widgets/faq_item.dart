// faq_item.dart
import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isRTL;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      leading: SizedBox(
        width: 24.w,
        height: 24.h,
        child: Center(
          child: Icon(
            CupertinoIcons.question_circle,
            color: const Color(0xff1E2644),
            size: 24.sp,
          ),
        ),
      ),
      title: Text(
        question,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isRTL ? 0 : 48.w,
            right: isRTL ? 48.w : 0,
            bottom: 16.h,
          ),
          child: Text(
            answer,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
