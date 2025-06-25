import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorOptionsSection extends StatelessWidget {
  final List<Color> availableColors;
  final int selectedColorIndex;
  final Function(int) onColorSelected;

  const ColorOptionsSection({
    super.key,
    required this.availableColors,
    required this.selectedColorIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        SectionTitle(
          title: 'product_info'.tr(context),
          titleSize: 16.sp,
          verticalPadding: 15.h,
        ),
        SizedBox(height: 15.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Label
            Text(
              'available_color'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff1E2644),
              ),
            ),

            SizedBox(width: 8.w),
            // Color options
            Expanded(
              child: availableColors.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(
                      height: 32.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: availableColors.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => onColorSelected(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 24.w,
                              height: 24.w,
                              margin: EdgeInsets.symmetric(horizontal: 8.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: availableColors[index],
                                border: Border.all(
                                  color: const Color(0xff36C4ED),
                                  width: 1.w,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
