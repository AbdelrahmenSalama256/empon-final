import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreLogoAndImage extends StatelessWidget {
  const StoreLogoAndImage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: isRTL
          ? [
              // RTL Layout: Reversed order
              // Location icon
              Container(
                width: 33.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.location_on,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),

              // Store logo
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/images/brand-logo.png',
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.contain,
                  ),
                  StoreNameWithVerification(
                    isVerified: false,
                    storeName: 'store_name'.tr(context),
                  ),
                ],
              ),

              // Product image
              Image.asset(
                'assets/images/test-product.png',
                width: 98.w,
                height: 88.w,
                fit: BoxFit.contain,
              ),
            ]
          : [
              // LTR Layout: Original order
              // Product image
              Image.asset(
                'assets/images/test-product.png', // Replace with the correct asset
                width: 98.w,
                height: 88.w,
                fit: BoxFit.contain,
              ),

              // Store logo
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align to the start for LTR
                children: [
                  Image.asset(
                    'assets/images/brand-logo.png',
                    width: 55.w,
                    height: 55.w,
                    fit: BoxFit.contain,
                  ),
                  StoreNameWithVerification(
                    isVerified: false,
                    storeName: 'store_name'.tr(context),
                  ),
                ],
              ),

              // Location icon
              Container(
                width: 33.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.location_on,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ],
    );
  }
}
