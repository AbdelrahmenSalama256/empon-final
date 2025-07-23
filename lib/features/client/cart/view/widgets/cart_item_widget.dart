import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/cart/data/model/cart_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel item;
  final Function(int) onQuantityChanged;
  final Function(int) onMenuPressed;
  final GlobalKey menuKey;

  const CartItemWidget({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onMenuPressed,
    required this.menuKey,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final separator = textDirection == TextDirection.rtl ? '، ' : ', ';

    // Build the description text conditionally
    String description = item.name;
    if (item.color != null && item.color is CartColor) {
      description = '${(item.color as CartColor).name}$separator$description';
    }
    description =
        '$description$separator${'cart_size_label'.tr(context)} ${item.attributes?.name ?? ''}';

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 1),
            blurRadius: 5,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              item.image,
              width: 119.w,
              height: 95.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 119.w,
                  height: 95.h,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: Image.asset(
                      'assets/images/placholder.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide.none,
                      ),
                      offset: const Offset(0, 50),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      onSelected: (value) {
                        if (value == 'favorite') {
                          onMenuPressed(0); // 0 for "Add to Favorites"
                        } else if (value == 'remove') {
                          onMenuPressed(1); // 1 for "Remove"
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem<String>(
                            value: 'favorite',
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/svg/heart.svg",
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'cart_add_to_favorites'.tr(context),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'remove',
                            child: Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.trash,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'cart_remove_from_list'.tr(context),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                description == null
                    ? const SizedBox.shrink()
                    : Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                SizedBox(height: description == null ? 4.h : 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textDirection == TextDirection.rtl
                          ? '${item.price} ${'currency_egp'.tr(context)}'
                          : '${'currency_egp'.tr(context)} ${item.price}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        _buildQuantityButton(
                          icon: Icons.add,
                          onPressed: () => onQuantityChanged(1),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          item.quantity.toString(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        _buildQuantityButton(
                          icon: Icons.remove,
                          onPressed: () => onQuantityChanged(-1),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 24.w,
        height: 24.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Icon(icon, size: 20.sp, color: const Color(0xff9B9B9B)),
        ),
      ),
    );
  }
}
