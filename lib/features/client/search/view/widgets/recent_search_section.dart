import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTap;

  const RecentSearchesSection({
    super.key,
    required this.recentSearches,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'recent_searches'.tr(context),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),

        SizedBox(height: 12.h),

        // Recent searches list
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: recentSearches.map((query) {
            return GestureDetector(
              onTap: () => onSearchTap(query),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  query,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
