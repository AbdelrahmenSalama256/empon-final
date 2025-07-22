import 'package:embone/features/client/shop/data/model/shop_response_model.dart';
import 'package:embone/features/client/shop/view/cubit/shop_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesFilter extends StatelessWidget {
  final ShopCubit cubit;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoriesFilter({
    super.key,
    required this.cubit,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = cubit.shopData?.data?.categories
            ?.map((categoryModel) => categoryModel.category)
            .whereType<CategoryDetail>()
            .toList() ??
        [];

    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category.name;

          return GestureDetector(
            onTap: () {
              if (category.name != null) {
                onCategorySelected(category.name ?? "");
              }
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: !isSelected ? Colors.grey.shade200 : Colors.white,
                      border: isSelected
                          ? Border.all(
                              color: const Color(0xff64B95C),
                              width: 2.w,
                            )
                          : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Image.network(
                        category.imageUrl ?? '',
                        width: 28.w,
                        height: 28.h,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    category.name ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff202727),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
