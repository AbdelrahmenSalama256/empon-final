import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/locale/app_loacl.dart';

class ProductCategorySection extends StatelessWidget {
  const ProductCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main Category Dropdown
        AppDropdownField(
          hint: 'main_category_hint'.tr(context),
          value: null,
          items: 'main_category_items'.tr(context).split(','),
          onChanged: (value) {},
          validator: (value) =>
              value == null ? 'field_required'.tr(context) : null,
        ),
        SizedBox(height: 20.h),

        // Subcategory Dropdown
        AppDropdownField(
          hint: 'subcategory_hint'.tr(context),
          value: null,
          items: 'subcategory_items'.tr(context).split(','),
          onChanged: (value) {},
          validator: (value) =>
              value == null ? 'field_required'.tr(context) : null,
        ),
        SizedBox(height: 20.h),

        // Brand Dropdown
        AppDropdownField(
          hint: 'brand_hint'.tr(context),
          value: null,
          items: 'brand_items'.tr(context).split(','),
          onChanged: (value) {},
          validator: (value) =>
              value == null ? 'field_required'.tr(context) : null,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
