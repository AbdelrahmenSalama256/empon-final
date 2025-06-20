import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreNameWithVerification extends StatelessWidget {
  final String storeName;
  final bool isVervied; // Assuming verification status is true

  const StoreNameWithVerification({super.key, required this.storeName, this.isVervied = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Visibility(
        visible: !isVervied,
          child: SizedBox(width: 24.w),
        ),
       Visibility(
        visible: isVervied,
          child: Image.asset(
            "assets/images/verify.png",
            width: 24.w,
            height: 24.h,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          storeName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff152354),
          ),
        ),
      ]),
    );
  }
}
