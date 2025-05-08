// ignore_for_file: deprecated_member_use, use_full_hex_values_for_flutter_colors

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/data/model/wishlist_model.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_buttons.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_details_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WishlistItemCard extends StatelessWidget {
  final dynamic item; // Can be FavoriteProductModel or FavoriteAccountModel
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
    final account = item as FavoriteAccountModel?;

    if (account == null) {
      return const Center(child: Text('Invalid account data'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            account.cover ?? '',
            width: 98.w,
            height: 88.h,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 98.w,
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
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  account.logo ?? '',
                  width: 55.w,
                  height: 55.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 55.w,
                      height: 55.w,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Icon(
                        CupertinoIcons.photo_camera_solid,
                        color: AppColors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (account.verified == true)
                    Image.asset(
                      "assets/images/verify.png",
                      width: 24.w,
                      height: 24.h,
                    ),
                  if (account.verified == true) SizedBox(width: 8.w),
                  Text(
                    account.name ?? '',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff152354),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        ActionButtons(
          isFavorite: account.verified ?? false,
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }

  Widget _buildProductLayout(bool isRTL) {
    final product = item as FavoriteProductModel?;

    if (product == null) {
      return const Center(child: Text('Invalid product data'));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Image.network(
            product.image ?? '',
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
        Expanded(
          child: ProductDetails(
            item: {
              'nameKey': product.name,
              'price': double.tryParse(product.price ?? '0') ?? 0.0,
              'brandKey': product.account?.name,
              'brandLogo': product.account?.logo,
              'image': product.image,
              'isFavorite': product.account?.verified ?? false,
            },
          ),
        ),
        ActionButtons(
          isFavorite: product.account?.verified ?? false,
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }
}
