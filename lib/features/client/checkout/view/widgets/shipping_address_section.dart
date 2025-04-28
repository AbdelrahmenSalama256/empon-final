import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShippingAddressSection extends StatelessWidget {
  final VoidCallback onChange;

  const ShippingAddressSection({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'checkout_shipping_address_title'.tr(context),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'checkout_available_address_label'.tr(context),
            style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            'checkout_sample_address'.tr(context),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
      actionText: 'checkout_change_action'.tr(context),
      onAction: onChange,
    );
  }
}

// Reusable Section Card Widget
class SectionCard extends StatelessWidget {
  final String title;
  final Widget content;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showHeader;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
    this.actionText,
    this.onAction,
    this.showHeader = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 0.5.w,
          // ignore: deprecated_member_use
          color: const Color(0xff000000).withOpacity(0.33),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (actionText != null && onAction != null)
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: Colors.red,
                    ),
                    child: Text(
                      actionText!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          if (showHeader) SizedBox(height: 16.h),
          if (!showHeader)
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                title,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          if (!showHeader) SizedBox(height: 16.h),
          content,
        ],
      ),
    );
  }
}
