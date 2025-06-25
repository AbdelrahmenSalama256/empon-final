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
  final String? type;
  final List<String> sizes;

  const ProductInfoSection({
    super.key,
    required this.name,
    required this.price,
    this.type,
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

  bool get _shouldShowSizeOptions {
    return widget.sizes.isNotEmpty &&
            widget.sizes.length == 1 &&
            widget.sizes.first == '0'
        ? false
        : widget.sizes.isNotEmpty;
  }

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
        if (widget.sellerName.isNotEmpty)
          _buildInfoRow('seller'.tr(context), widget.sellerName),
        if (widget.sellerName.isNotEmpty) SizedBox(height: 16.h),
        if (widget.productId.isNotEmpty)
          _buildInfoRow('serial_number'.tr(context), widget.productId),
        if (widget.productId.isNotEmpty) SizedBox(height: 16.h),
        if (_shouldShowSizeOptions) ...[
          Text(
            'choose_size'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff1E2644),
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            children:
                widget.sizes.map((size) => _buildSizeOption(size)).toList(),
          ),
        ] else if (widget.sizes.isNotEmpty && widget.sizes.first == '0') ...[
          SizedBox(height: 18.h),
          Center(
            child: Text(
              widget.type == "services"
                  ? 'no_sizes_available_for_this_service'.tr(context)
                  : 'no_sizes_available'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xffA0A0A0),
              ),
            ),
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
      onTap: () => setState(() => selectedSize = size),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffF6F6F6) : Colors.white,
          border: Border.all(
            color:
                isSelected ? const Color(0xff1E2644) : const Color(0xffF6F6F6),
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
