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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // GestureDetector(
        //   onTap: onTap,
        //   child: Visibility(
        //     visible: isVerified,
        //     child: Container(
        //       width: 35.w,
        //       height: 35.w,
        //       decoration: BoxDecoration(
        //         color: AppColors.primary,
        //         borderRadius: BorderRadius.circular(8.r),
        //       ),
        //       child: Icon(
        //         CupertinoIcons.globe,
        //         size: 20.sp,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        const SizedBox.shrink(),
        // const Spacer(),
        Center(
          child: StoreNameWithVerification(
            isVerified: isVerified,
            storeName: name,
          ),
        ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(3.w, 3.h),
                    blurRadius: 6.r,
                    spreadRadius: 1.r,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    offset: Offset(-2.w, -2.h),
                    blurRadius: 4.r,
                    spreadRadius: 0.5.r,
                  ),
                ],
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
