import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessAccountOption extends StatelessWidget {
  final String name;
  final String imagePath;
  final bool isSelected;
  final String labelText;
  final Color labelColor;
  final VoidCallback onTap;
  final bool showLabel;

  const BusinessAccountOption({
    super.key,
    required this.name,
    this.showLabel = false,
    required this.imagePath,
    required this.isSelected,
    required this.labelText,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              offset: Offset(0, 1),
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Store logo
            imagePath.startsWith('http')
                ? CircleAvatar(
                    radius: 30.r,
                    backgroundImage: NetworkImage(imagePath),
                  )
                : CircleAvatar(
                    radius: 30.r,
                    backgroundImage: const AssetImage('assets/images/logo.png')
                        as ImageProvider,
                  ),
            SizedBox(width: 12.w),
            // Store name
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            // Status label
            if (showLabel &&
                labelText != null) // Only show if showLabel is true
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: labelColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: labelColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: labelColor,
                  ),
                ),
              ),
            SizedBox(width: 12.w),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                ),
                color: isSelected ? AppColors.primary : Colors.white,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.sp,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
