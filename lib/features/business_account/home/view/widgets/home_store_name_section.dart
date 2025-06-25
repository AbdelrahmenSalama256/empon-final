import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreNameSection extends StatelessWidget {
  final String name;
  final bool isVerified;
  final VoidCallback onTap;
  const HomeStoreNameSection(
      {super.key,
      required this.name,
      required this.isVerified,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Visibility(
            visible: isVerified,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                CupertinoIcons.globe,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: StoreNameWithVerification(
            storeName: name,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          child: Visibility(
            visible: isVerified,
            child: Container(
              width: 35.w,
              height: 35.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                CupertinoIcons.location_solid,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
