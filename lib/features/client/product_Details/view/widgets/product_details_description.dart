import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDescriptionSection extends StatefulWidget {
  final String description;

  const ProductDescriptionSection({super.key, required this.description});

  @override
  State<ProductDescriptionSection> createState() =>
      _ProductDescriptionSectionState();
}

class _ProductDescriptionSectionState extends State<ProductDescriptionSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        SectionTitle(
          title: 'product_details'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),

        SizedBox(height: 16.h),

        // Shipment details
        _buildInfoRow(
          context,
          label: 'condition'.tr(context),
          value: 'condition_value'.tr(context),
        ),

        SizedBox(height: 16.h),

        _buildInfoRow(
          context,
          label: 'durability'.tr(context),
          value: 'durability_value'.tr(context),
        ),

        SizedBox(height: 16.h),

        _buildInfoRow(
          context,
          label: 'quality'.tr(context),
          value: 'quality_value'.tr(context),
        ),

        // Description (hidden by default, shown when "See More" is clicked)
        if (_isExpanded) ...[
          SizedBox(height: 16.h),
          Text(
            widget.description,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
        ],

        SizedBox(height: 16.h),

        // See More / See Less link
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Text(
            _isExpanded ? 'see_less'.tr(context) : 'see_more'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
  }) {
    // Define the label and value widgets once
    final labelWidget = Text(
      label,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );

    final valueWidget = Expanded(
      child: Text(
        value,
        style: TextStyle(
          fontSize: 14.sp,
          color: valueColor ?? Colors.grey.shade600,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (isRTL) ...[
        //   labelWidget,
        //   SizedBox(width: 16.w),
        //   valueWidget,
        // ] else ...[
        //   valueWidget,
        //   SizedBox(width: 16.w),
        //   labelWidget,
        // ],
        labelWidget,
        SizedBox(width: 16.w),
        valueWidget,
      ],
    );
  }
}
