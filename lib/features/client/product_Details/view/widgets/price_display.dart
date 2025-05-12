import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PriceDisplay extends StatelessWidget {
  final double currentPrice;
  final double? originalPrice;
  final String currency;

  const PriceDisplay({
    super.key,
    required this.currentPrice,
    this.originalPrice,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/svg/local_price.svg",
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(width: 10.w),
          Text(
            currentPrice.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff152354),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            currency,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff152354),
            ),
          ),
          if (originalPrice != null) ...[
            SizedBox(width: 16.w),
            Text(
              originalPrice!.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.lineThrough,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              currency,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff152354),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
