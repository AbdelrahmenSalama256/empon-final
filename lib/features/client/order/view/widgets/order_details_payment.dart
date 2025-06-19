import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentMethod extends StatelessWidget {
  final String type;

  const PaymentMethod({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'payment_method'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xff222222),
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              SizedBox(
                width: 40.w,
                height: 40.h,
                child: SvgPicture.asset(
                  "assets/images/svg/cash-on-delivery.svg",
                  width: 24.w,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                type.tr(context),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
