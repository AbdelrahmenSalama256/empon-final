// ignore_for_file: deprecated_member_use, use_full_hex_values_for_flutter_colors

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_buttons.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_details_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isBrand;
  final VoidCallback? onRemove;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onAddToCart;

  const WishlistItemCard({
    super.key,
    required this.item,
    this.isBrand = false,
    this.onRemove,
    this.onToggleFavorite,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Container(
      // margin: EdgeInsets.all(16.w),
      // padding: EdgeInsets.all(isBrand ? 16.w : 0),
      height: isBrand ? 120.h : 100.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0xff0000000F),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: isBrand ? _buildBrandLayout(isRTL) : _buildProductLayout(isRTL),
    );
  }

  Widget _buildBrandLayout(bool isRTL) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,

      //
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            item['image'],
            width: 98.w,
            height: 88.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100.w,
                height: 200.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Icon(
                  CupertinoIcons.photo_camera_solid,
                  color: AppColors.white,
                ),
              );
            },
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  item['brandLogo'],
                  width: 55.w,
                  height: 55.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.asset(
                  "assets/images/verify.png",
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(width: 8.w),
                Text(
                  item['brandKey'],
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff152354),
                  ),
                ),
              ]),
            ),
          ],
        ),
        // Action Buttons
        const Spacer(),
        ActionButtons(
          isFavorite: item['isFavorite'],
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }

  Widget _buildProductLayout(bool isRTL) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      //
      children: [
        // Product Image
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.asset(
            item['image'],
            width: 98.w,
            height: 88.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                ),
                child: const Icon(CupertinoIcons.photo_camera_solid),
              );
            },
          ),
        ),

        // Product Details
        Expanded(
          child: ProductDetails(
            item: item,
          ),
        ),

        // Action Buttons
        // const Spacer(),
        ActionButtons(
          isFavorite: item['isFavorite'],
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }
}
