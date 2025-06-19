import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TransactionItem extends StatelessWidget {
  final String amount;
  final bool isDeposit;
  final String description;
  final String date;

  const TransactionItem({
    super.key,
    required this.amount,
    required this.isDeposit,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.w),
        border: Border.all(
          color: const Color(0xffF0F2F9),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 49.w,
            height: 49.h,
            padding: EdgeInsets.all(12.w),
            decoration: const BoxDecoration(
              color: Color(0xffDBF7D9),
              // borderRadius: BorderRadius.circular(8.r),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              "assets/images/svg/wallet.svg",
              // color: isDeposit ? Colors.green : AppColors.primary,
              width: 26.w,
              height: 26.h,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff333333),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff8F95AB),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isDeposit ? '' : ''}$amount ${'egp'.tr(context)}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color:
                  isDeposit ? const Color(0xff64B95C) : const Color(0xffD20101),
            ),
          ),
        ],
      ),
    );
  }
}
