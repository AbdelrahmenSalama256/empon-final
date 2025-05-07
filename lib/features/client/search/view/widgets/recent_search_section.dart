import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/search/data/model/search_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<SearchHistoryItem> recentSearches;
  final Function(String) onSearchTap;
  final Function(int) onRemoveTap;

  const RecentSearchesSection({
    super.key,
    required this.recentSearches,
    required this.onSearchTap,
    required this.onRemoveTap,
  });

  @override
  Widget build(BuildContext context) {
    return recentSearches.isEmpty
        ? const SizedBox.shrink()
        : Column(
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
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => onSearchTap(query.search),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            query.search,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => onRemoveTap(query.id),
                        icon: Icon(
                          CupertinoIcons.xmark,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                      )
                    ],
                  );
                }).toList(),
              ),
            ],
          );
  }
}
