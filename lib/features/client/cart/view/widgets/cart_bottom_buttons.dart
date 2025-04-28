import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartBottomButtons extends StatelessWidget {
  final VoidCallback onCheckoutPressed;
  final VoidCallback onContinueShoppingPressed;

  const CartBottomButtons({
    super.key,
    required this.onCheckoutPressed,
    required this.onContinueShoppingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Checkout button (Primary)
          AppButton(
            text: 'cart_checkout'.tr(context),
            onPressed: onCheckoutPressed,
            type: AppButtonType.primary,
            height: 50.h,
            isFullWidth: true,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          SizedBox(height: 12.h),

          // Continue shopping button (Secondary)
          AppButton(
            text: 'cart_continue_shopping'.tr(context),
            onPressed: onContinueShoppingPressed,
            type: AppButtonType.secondary,
            height: 50.h,
            isFullWidth: true,
            textStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1565C0),
            ),
          ),
        ],
      ),
    );
  }
}
