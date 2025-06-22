import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showVariationBottomSheet(
  BuildContext context, {
  required int productId,
  required List<Variation> variations,
}) {
  int selectedVariationIndex = 0;
  int quantity = 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'select_variation'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                // Size Selection
                if (variations.isNotEmpty) ...[
                  Text(
                    'size'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    children: variations.asMap().entries.map((entry) {
                      final index = entry.key;
                      final variation = entry.value;
                      final isSelected = selectedVariationIndex == index;
                      return ChoiceChip(
                        label: Text(
                          variation.attributeValue?.name ?? 'N/A',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        selected: isSelected,
                        backgroundColor: Colors.grey[200],
                        selectedColor: const Color(0xFF2F76DB),
                        onSelected: (bool selected) {
                          setState(() {
                            selectedVariationIndex = index;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                ],
                // Color Selection (if available)
                if (variations.any((v) => v.color != null)) ...[
                  Text(
                    'color'.tr(context),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.w,
                    children: variations
                        .asMap()
                        .entries
                        .where((entry) => entry.value.color != null)
                        .map((entry) {
                      final index = entry.key;
                      final variation = entry.value;
                      final isSelected = selectedVariationIndex == index;
                      final colorCode = variation.color?.code ?? '#000000';
                      final color =
                          Color(int.parse(colorCode.replaceFirst('#', '0xff')));
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedVariationIndex = index;
                          });
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF2F76DB)
                                  : Colors.grey,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                ],
                // Quantity Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'quantity'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, size: 20.sp),
                          onPressed: quantity > 1
                              ? () {
                                  setState(() {
                                    quantity--;
                                  });
                                }
                              : null,
                        ),
                        Text(
                          '$quantity',
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        IconButton(
                          icon: Icon(Icons.add, size: 20.sp),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                // Add to Cart Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F76DB),
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () {
                      final selectedVariation =
                          variations[selectedVariationIndex];
                      context.read<CartCubit>().addProductToCart(
                            productId: productId,
                            variationId:
                                selectedVariation.attributeValue?.id ?? 0,
                            quantity: quantity,
                          );
                      Navigator.pop(context); // Close bottom sheet
                      showToast(
                        context,
                        message: 'added_to_cart'.tr(context),
                        state: ToastStates.success,
                      );
                    },
                    child: Text(
                      'add_to_cart'.tr(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      );
    },
  );
}
