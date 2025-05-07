import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onClose;
  final bool showCloseButton;
  final double? height;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool isNetworkImage;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onClose,
    this.showCloseButton = true,
    this.height,
    this.backgroundColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      padding: padding.add(EdgeInsets.symmetric(vertical: 4.h)),
      decoration: BoxDecoration(color: backgroundColor),
      child: Row(
        children: [
          if (imageUrl != null)
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: isNetworkImage
                    ? Image.network(
                        imageUrl!,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildErrorWidget(),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        imageUrl!,
                        width: 48.w,
                        height: 48.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildErrorWidget(),
                      ),
              ),
            ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xff8F95AB),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              icon: Icon(
                CupertinoIcons.xmark,
                size: 18.sp,
                color: AppColors.black,
              ),
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(
                minWidth: 40.w,
                minHeight: 40.h,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: 48.w,
      height: 48.w,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 20.sp,
        color: Colors.grey,
      ),
    );
  }
}
