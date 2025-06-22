import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';
import 'package:embone/features/client/checkout/view/empon_wallet_screen.dart';
import 'package:embone/features/client/checkout/view/widgets/shipping_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PaymentMethodSection extends StatelessWidget {
  const PaymentMethodSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final checkoutCubit = context.read<CheckoutCubit>();
        final grandTotal = checkoutCubit.orderResponse?.data?.grandTotal ?? 0.0;

        return SectionCard(
          title: 'checkout_choose_payment_method_title'.tr(context),
          content: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmponWalletScreen(
                        grandTotal: double.parse(grandTotal.toString()),
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 80.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 70.w,
                        height: 50.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.w,
                          vertical: 0.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: SvgPicture.asset(
                          'assets/images/svg/cash-on-delivery.svg',
                          width: 40.w,
                          height: 40.h,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'empon_wallet'.tr(context),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
