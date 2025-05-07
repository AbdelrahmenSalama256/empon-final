import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/search/data/model/search_recent_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentlyViewedSection extends StatelessWidget {
  final List<RecentViewItem> recentlyViewed;
  final Function(int) onItemTap;
  final VoidCallback onClearTap;

  const RecentlyViewedSection({
    super.key,
    required this.recentlyViewed,
    required this.onItemTap,
    required this.onClearTap,
  });

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('confirm_title'.tr(context)),
        content: Text('confirm_message'.tr(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('cancel'.tr(context)),
          ),
          TextButton(
            onPressed: () {
              onClearTap();
            },
            child: Text('clear'.tr(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'recently_viewed'.tr(context),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true,
            itemCount: recentlyViewed.length,
            itemBuilder: (context, index) {
              final item = recentlyViewed[index];
              return GestureDetector(
                onTap: () => onItemTap(item.id),
                onLongPress: () => _showClearConfirmationDialog(context),
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
                    child: Image.network(
                      item.imageUrl,
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
