// ignore_for_file: deprecated_member_use

import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductInfoSection extends StatefulWidget {
  final String name;
  final double price;
  final String currency;
  final String sellerName;
  final String productId;

  const ProductInfoSection({
    super.key,
    required this.name,
    required this.price,
    required this.currency,
    required this.sellerName,
    required this.productId,
  });

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  // Sample sizes
  final List<String> sizes = ['37', '38', '39', '40', '41', '42'];
  final List<String> unavailableSizes = ['38']; // Size 38 is unavailable
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        SectionTitle(
          title: 'product_info'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),

        SizedBox(height: 16.h),

        // Product information with aligned labels and values
        _buildInfoRow('seller'.tr(context), widget.sellerName),

        SizedBox(height: 16.h),

        _buildInfoRow('serial_number'.tr(context), widget.productId),

        SizedBox(height: 18.h),

        // Size selector
        Text(
          'choose_size'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xff1E2644),
          ),
        ),

        SizedBox(height: 16.h),

        // Size options
        Row(
          children: [
            for (int i = sizes.length - 1; i >= 0; i--)
              _buildSizeOption(sizes[i]),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        // Fixed width container for labels to ensure alignment
        SizedBox(
          width: 120.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1E2644),
            ),
          ),
        ),
        // Value with flexible width
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xffA0A0A0)),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    final isUnavailable = unavailableSizes.contains(size);
    final isSelected = selectedSize == size;

    return GestureDetector(
      onTap: isUnavailable
          ? null
          : () {
              setState(() {
                selectedSize = size;
              });
            },
      child: Container(
        width: 40.w,
        height: 40.w,
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: isUnavailable ? Colors.grey.shade200 : Colors.white,
          border: Border.all(
            color: const Color(0xffF6F6F6),
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isUnavailable
                  ? Colors.grey.shade400
                  : const Color(0xff1E2644),
            ),
          ),
        ),
      ),
    );
  }
}
