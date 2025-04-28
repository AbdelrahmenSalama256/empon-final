import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Color titleColor;
  final double titleSize;
  final FontWeight titleWeight;
  final Color dividerColor;
  final double dividerHeight;
  final double verticalPadding;

  const SectionTitle({
    super.key,
    required this.title,
    this.titleColor = Colors.black,
    this.titleSize = 18,
    this.titleWeight = FontWeight.bold,
    this.dividerColor = const Color(0xffCCCCCC),
    this.dividerHeight = 0.5,
    this.verticalPadding = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize.sp,
            fontWeight: titleWeight,
            color: titleColor,
          ),
        ),
        SizedBox(height: verticalPadding.h),
        Divider(
          height: dividerHeight.h,
          color: dividerColor,
        ),
      ],
    );
  }
}
