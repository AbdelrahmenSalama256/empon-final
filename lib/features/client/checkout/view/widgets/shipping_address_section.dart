import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShippingAddressSection extends StatelessWidget {
  final Address? address;
  final VoidCallback onChange;

  const ShippingAddressSection({
    super.key,
    this.address,
    required this.onChange,
  });

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
          if (address != null)
            Text(
              _buildAddressText(address!),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          else
            Text(
              'no_address_selected'.tr(context),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
        ],
      ),
      actionText: 'checkout_change_action'.tr(context),
      onAction: onChange,
    );
  }

  String _buildAddressText(Address address) {
    final addressParts = [
      if (address.address != null) address.address,
      if (address.city != null) address.city,
      if (address.state != null) address.state,
      if (address.country != null) address.country,
    ].where((part) => part != null && part.isNotEmpty).toList();

    final addressString =
        addressParts.isNotEmpty ? addressParts.join(', ') : 'عنوان غير محدد';
    return address.name != null
        ? '${address.name}: $addressString'
        : addressString;
  }
}

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
