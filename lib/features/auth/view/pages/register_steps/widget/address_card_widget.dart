import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressCardWidget extends StatelessWidget {
  final String address;
  final bool isAddressSelected;
  final VoidCallback onConfirm;

  const AddressCardWidget({
    Key? key,
    required this.address,
    required this.isAddressSelected,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: EdgeInsets.all(24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selected_address'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F9),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.lightGrey, width: 1.w),
            ),
            child: Row(
              children: [
                Icon(CupertinoIcons.location_solid,
                    color: AppColors.primary, size: 24.w),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    address,
                    style: TextStyle(
                        fontSize: 14.sp, color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AppButton(
            onPressed: isAddressSelected ? onConfirm : null,
            text: 'confirm_location'.tr(context),
            height: 50.h,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
