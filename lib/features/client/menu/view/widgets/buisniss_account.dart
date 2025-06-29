import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/create_business_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessAccountSection extends StatelessWidget {
  const BusinessAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateWithoutNav(context, const CreateBusinessAccountTypePage());
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.add, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                "create_business_account".tr(context),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Container(
            width: 25.w,
            height: 25.h,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24.w,
            ),
          ),
        ],
      ),
    );
  }
}
