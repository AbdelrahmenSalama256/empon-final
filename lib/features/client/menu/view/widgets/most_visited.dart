import 'package:embone/core/constants/widgets/custom_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VisitedItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onTap;

  const VisitedItem({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onTap, // Optional onTap parameter
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Handle tap event
      child: SizedBox(
        width: 70.w,
        child: Column(
          children: [
            CustomCachedImage(
              imageUrl: imageUrl.isEmpty ? null : imageUrl,
              h: 60.h,
              w: 60.w,
              borderRadius: 30.r,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.h),
            Text(
              name,
              style: TextStyle(fontSize: 12.sp),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
