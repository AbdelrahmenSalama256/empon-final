import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';

class HomeStoreProducts extends StatelessWidget {
 final int totalProduct;
   const HomeStoreProducts({super.key, required this.totalProduct});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$totalProduct ${"products".tr(context)}',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff1E2644),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: AppButton(
            text: "add_product".tr(context),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            height: 40.h,
            borderRadius: BorderRadius.circular(10.r),
            onPressed: () {
              

            },
            prefixIcon: Icon(
              CupertinoIcons.add,
              size: 20.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
