import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreProducts extends StatelessWidget {
  final int id;
  final int totalProduct;
  final bool? isVendor;

  const HomeStoreProducts(
      {super.key,
      required this.totalProduct,
      required this.id,
      this.isVendor = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$totalProduct ${"products".tr(context)}',
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff1E2644),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          // flex: 3,
          child: AppButton(
            text: "add_product_or_service".tr(context),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            // height: 30.h,
            // width: 400.w,
            borderRadius: BorderRadius.circular(10.r),
            onPressed: () {
              // Navigate to add product page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                         AddProductPage(businessAccountId: id)
                          ));
            },
            prefixIcon: Icon(
              CupertinoIcons.add,
              size: 18.sp,
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
