// ignore_for_file: deprecated_member_use

import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummary extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const OrderSummary({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          width: 0.5.w,
          color: const Color(0xff000000).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'products_total'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xff9B9B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Delivery Fee
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'delivery_fee'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xff9B9B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$${deliveryFee.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: const Color(0XFF000000).withOpacity(0.2), height: 1.h),
          SizedBox(height: 12.h),

          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'total_amount'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xff9B9B9B),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
