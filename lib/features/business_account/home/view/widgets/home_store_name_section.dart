import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_name.dart';

class HomeStoreNameSection extends StatelessWidget {
  final String name ;
  final bool isVerified; // Assuming verification status is true
  const HomeStoreNameSection({super.key , required this.name, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: StoreNameWithVerification(
            storeName: name,
          ),
        ),
        const Spacer(),
        Visibility(
          visible:isVerified,
          child: Container(
            width: 33.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.location_on,
              size: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
