import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemMenu extends StatelessWidget {
  final VoidCallback onRemove;
  final VoidCallback onAddToFavorites;
  final String imageUrl;

  const CartItemMenu({
    super.key,
    required this.onRemove,
    required this.onAddToFavorites,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    return Container(
      width: 300.w, // Adjust width to match the design
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        textDirection: textDirection,
        children: [
          // Menu options
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.favorite_border,
                  title: 'cart_move_to_favorites'.tr(context),
                  onTap: onAddToFavorites,
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.delete_outline,
                  title: 'cart_remove_from_cart'.tr(context),
                  onTap: onRemove,
                ),
              ],
            ),
          ),

          // Background image
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
                opacity: 0.1, // Faded effect as in the image
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final textDirection = Directionality.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Row(
          textDirection: textDirection,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                textDirection: textDirection,
              ),
            ),
            Icon(icon, color: Colors.grey.shade600, size: 20.sp),
          ],
        ),
      ),
    );
  }
}
