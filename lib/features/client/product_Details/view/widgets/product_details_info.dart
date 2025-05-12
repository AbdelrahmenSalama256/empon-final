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
  final List<String> sizes;

  const ProductInfoSection({
    super.key,
    required this.name,
    required this.price,
    required this.currency,
    required this.sellerName,
    required this.productId,
    required this.sizes,
  });

  @override
  State<ProductInfoSection> createState() => _ProductInfoSectionState();
}

class _ProductInfoSectionState extends State<ProductInfoSection> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'product_info'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),
        SizedBox(height: 16.h),
        _buildInfoRow('seller'.tr(context), widget.sellerName),
        SizedBox(height: 16.h),
        _buildInfoRow('serial_number'.tr(context), widget.productId),
        if (widget.sizes.isNotEmpty) ...[
          SizedBox(height: 18.h),
          Text(
            'choose_size'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff1E2644),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              for (int i = widget.sizes.length - 1; i >= 0; i--)
                _buildSizeOption(widget.sizes[i]),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
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
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xffA0A0A0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    final isSelected = selectedSize == size;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSize = size;
        });
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        margin: EdgeInsets.only(left: 8.w),
        decoration: BoxDecoration(
          color: Colors.white,
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
              color: const Color(0xff1E2644),
            ),
          ),
        ),
      ),
    );
  }
}
