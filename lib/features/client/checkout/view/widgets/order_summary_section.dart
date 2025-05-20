import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummarySection extends StatelessWidget {
  final CheckoutCubit checkoutCubit;
  const OrderSummarySection({super.key, required this.checkoutCubit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.5.w,
          // ignore: deprecated_member_use
          color: const Color(0xff000000).withOpacity(0.33),
        ),
      ),
      child: Column(
        children: [
          _OrderSummaryRow(
            label: 'checkout_products_total_label'.tr(context),
            value: checkoutCubit.cartInfoModel?.data?.items
                    ?.fold<double>(0, (sum, item) => sum + item.totalPrice)
                    .toStringAsFixed(2) ??
                '0',
          ),

          SizedBox(height: 12.h),
          // _OrderSummaryRow(
          //   label: 'checkout_delivery_fees_label'.tr(context),
          //   value: '\$5.00',
          // ),
          // SizedBox(height: 12.h),
          Divider(height: 1.h, color: Colors.grey[300]),
          SizedBox(height: 12.h),
          _OrderSummaryRow(
            label: 'checkout_total_amount_label'.tr(context),
            value: "${checkoutCubit.cartInfoModel?.data?.totalOrderPrice}",
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _OrderSummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xff9B9B9B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
