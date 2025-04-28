import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorProductActions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VendorProductActions({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onEdit,
          child: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xffE6E6E6), width: 1.5.w),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              CupertinoIcons.pencil,
              color: Colors.black,
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          width: 40.w,
          height: 40.h,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: const Color(0xffEC4B4B),
            border: Border.all(color: const Color(0xffE6E6E6), width: 1.5.w),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Image.asset(
            "assets/images/trash.png",
            width: 16.w,
            height: 16.h,
          ),
        ),
      ],
    );
  }
}
