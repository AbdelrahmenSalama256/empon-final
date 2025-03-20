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
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: height,
      width: double.infinity,
      padding: padding.add(EdgeInsets.only(top: 4.h, bottom: 4.h)),
      decoration: BoxDecoration(
        color: backgroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 4.r,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Leading section: Close button or empty space
          isRTL
              ? (showCloseButton
                  ? IconButton(
                      icon: Icon(
                        CupertinoIcons.xmark,
                        size: 17.sp,
                        color: AppColors.black,
                      ),
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 40.h,
                      ),
                    )
                  : SizedBox(width: 40.w))
              : Expanded(
                  child: Row(
                    mainAxisAlignment:
                        isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      // Image (if provided)
                      if (imageUrl != null)
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              imageUrl!,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 48.w,
                                height: 48.w,
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 20.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (imageUrl != null) SizedBox(width: 12.w),
                      // Title and subtitle
                      Column(
                        crossAxisAlignment: isRTL
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          // Subtitle (if provided)
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
                    ],
                  ),
                ),

          // Trailing section: Close button or empty space
          isRTL
              ? Expanded(
                  child: Row(
                    mainAxisAlignment:
                        isRTL ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      // Title and subtitle
                      Column(
                        crossAxisAlignment: isRTL
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.black,
                            ),
                          ),
                          // Subtitle (if provided)
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
                      if (imageUrl != null) SizedBox(width: 12.w),
                      // Image (if provided)
                      if (imageUrl != null)
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: Image.asset(
                              imageUrl!,
                              width: 48.w,
                              height: 48.w,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                width: 48.w,
                                height: 48.w,
                                color: Colors.grey.shade200,
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 20.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : (showCloseButton
                  ? IconButton(
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
                    )
                  : SizedBox(width: 40.w)),
        ],
      ),
    );
  }
}
