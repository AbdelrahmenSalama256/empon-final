import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturesSection extends StatelessWidget {
  final List< String>? features;

  const FeaturesSection({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    if (features == null || features!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: 'features'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),
        SizedBox(height: 16.h),
        ...features!.map((entry) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      entry,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff1E2644),
                      ),
                    ),
                  ),
                ],
              ),
            )),
        SizedBox(height: 15.h),
      ],
    );
  }
}
