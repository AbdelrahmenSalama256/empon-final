import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelectorSection extends StatelessWidget {
  final bool? isVendor;
  final int quantity;
  final int maxQuantity; // Added to limit quantity based on stock
  final Function(int) onQuantityChanged;

  const QuantitySelectorSection({
    super.key,
    this.isVendor,
    required this.quantity,
    required this.maxQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isVendor != false
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'number'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1E2644),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '33', // Replace with dynamic value if available
                style: TextStyle(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff222222),
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'quantity'.tr(context),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1E2644),
                ),
              ),
              SizedBox(width: 20.w),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (quantity > 1) {
                          onQuantityChanged(quantity - 1);
                        }
                      },
                    ),
                    Container(
                      width: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        quantity.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff1E2644),
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onPressed: () {
                        if (quantity < maxQuantity) {
                          PrintUtil.info('Increase quantity: $quantity');
                          onQuantityChanged(quantity + 1);
                        } else {
                          PrintUtil.info(
                              'Maximum quantity ($maxQuantity) reached');
                          showToast(context,
                              message: "maximum_quantity_reached".tr(context),
                              state: ToastStates.error);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: Icon(icon, size: 16.w, color: AppColors.primary),
      ),
    );
  }
}
