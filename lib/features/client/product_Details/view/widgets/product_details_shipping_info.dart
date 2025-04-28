import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShippingInfoSection extends StatelessWidget {
  // Dynamic data that will come from the backend
  final String startDate;
  final String endDate;
  final String price;
  final String origin;

  const ShippingInfoSection({
    super.key,
    this.startDate = "1 مارس", // Default for testing
    this.endDate = "3 مارس", // Default for testing
    this.price = "2500", // Default for testing
    this.origin = "تركيا", // Default for testing
  });

  @override
  Widget build(BuildContext context) {
    // final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        SectionTitle(
          title: 'shipping_information'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),

        SizedBox(height: 16.h),

        // Shipping details
        _buildInfoRow(
          context,
          label: 'estimated_delivery'.tr(context),
          value:
              '${'from'.tr(context)} $startDate ${'to'.tr(context)} $endDate',
        ),

        SizedBox(height: 16.h),

        _buildInfoRow(
          context,
          label: 'free_shipping'.tr(context),
          value:
              '${'for_orders_above'.tr(context)} $price ${'egp'.tr(context)}',
        ),

        SizedBox(height: 16.h),

        _buildInfoRow(
          context,
          label: 'total_amount'.tr(context),
          value: 'vat_included'.tr(context),
        ),

        SizedBox(height: 16.h),

        _buildInfoRow(
          context,
          label: 'consumer_info'.tr(context),
          value: '${'products_from'.tr(context)} $origin',
          valueColor: Colors.blue,
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
