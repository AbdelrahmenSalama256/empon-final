import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../auth/data/models/user_data_model.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onSelect;
  final VoidCallback? onChange;
  final bool isSelectable;
  final bool isSelected;
  final bool showChangeButton;

  const AddressCard({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onDelete,
    this.onSelect,
    this.onChange,
    this.isSelectable = false,
    this.isSelected = false,
    this.showChangeButton = false,
  });

  String get _title =>
      address.name ?? address.city ?? address.address ?? 'عنوان غير محدد';

  String get _fullAddress {
    final parts = [
      if (address.address != null) address.address,
      if (address.city != null) address.city,
      if (address.state != null) address.state,
      if (address.country != null) address.country,
    ].where((part) => part != null && part.isNotEmpty).toList();
    return parts.isNotEmpty ? parts.join(', ') : 'العنوان غير محدد';
  }

  bool get _isDefault => address.isDefault ?? false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelectable ? onSelect : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 70,
              spreadRadius: 0,
              color: Color(0x0F000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.location_solid,
                    color: Colors.black, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    _title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isSelectable)
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected ? Colors.green : Colors.grey,
                    size: 20.sp,
                  ),
                if (_isDefault && !isSelectable)
                  Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'افتراضي',
                      style:
                          TextStyle(fontSize: 10.sp, color: Colors.green[800]),
                    ),
                  ),
                if (showChangeButton && !isSelectable)
                  IconButton(
                    icon: Icon(Icons.edit, size: 20.sp),
                    onPressed: onChange,
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              _fullAddress,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff7C7C7C),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isSelectable && !showChangeButton) ...[
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onPressed: onEdit,
                      text: 'edit_address'.tr(context),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      prefixIcon: Icon(CupertinoIcons.pen,
                          color: Colors.white, size: 18.sp),
                      borderRadius: BorderRadius.circular(13.r),
                      textStyle: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: AppButton(
                      onPressed: onDelete,
                      text: 'delete_address'.tr(context),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      prefixIcon: Icon(CupertinoIcons.trash,
                          color: Colors.white, size: 18.sp),
                      borderRadius: BorderRadius.circular(13.r),
                      textStyle: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w500),
                      backgroundColor: AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
