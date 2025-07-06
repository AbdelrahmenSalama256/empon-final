import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/addresses_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class AddressesSection extends StatelessWidget {
  const AddressesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return GestureDetector(
      onTap: () {
        navigateTo(context, const AddressesScreen());
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/images/svg/location_on.svg",
                    width: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  "addresses".tr(context),
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
