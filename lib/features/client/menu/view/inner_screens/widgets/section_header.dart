// section_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isRTL;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.isRTL,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: const Color(0xffDB3022),
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 8.h),
          Text(
            subtitle!,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        SizedBox(height: 16.h),
      ],
    );
  }
}
