import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentlyViewedSection extends StatelessWidget {
  final List<Map<String, dynamic>> recentlyViewed;
  final Function(int) onItemTap;

  const RecentlyViewedSection({
    super.key,
    required this.recentlyViewed,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'recently_viewed'.tr(context),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),

        SizedBox(height: 12.h),

        // Recently viewed items grid
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // For RTL layout
            itemCount: recentlyViewed.length,
            itemBuilder: (context, index) {
              final item = recentlyViewed[index];
              return GestureDetector(
                onTap: () => onItemTap(item['id']),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 24.w,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
