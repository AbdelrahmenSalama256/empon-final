import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummarySection extends StatelessWidget {
  final CheckoutCubit checkoutCubit;
  final CartCubit cartCubit;
  

  const OrderSummarySection({
    super.key,
    required this.checkoutCubit,
    required this.cartCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      bloc: checkoutCubit,
      builder: (context, state) {
        final totalProducts = cartCubit.cartItems.length;
        final grandTotal = checkoutCubit.orderResponse?.data?.grandTotal ?? 0.0;

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              width: 0.5.w,
              color: const Color(0xff000000).withOpacity(0.33),
            ),
          ),
          child: Column(
            children: [
              _OrderSummaryRow(
                label: 'checkout_products_total_label'.tr(context),
                value: totalProducts.toString(),
              ),
              SizedBox(height: 12.h),
              Divider(height: 1.h, color: Colors.grey[300]),
              SizedBox(height: 12.h),
              _OrderSummaryRow(
                label: 'checkout_total_amount_label'.tr(context),
                valueWidget: state is CheckoutLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        '$grandTotal',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                isTotal: true,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummaryRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? valueWidget;
  final bool isTotal;

  const _OrderSummaryRow({
    required this.label,
    this.value,
    this.valueWidget,
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
        valueWidget ??
            Text(
              value ?? 'N/A',
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
