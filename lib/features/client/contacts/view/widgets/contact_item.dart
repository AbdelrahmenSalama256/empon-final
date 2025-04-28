import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/network/local_network.dart';
import '../../../../../core/services/service_locator.dart';
import '../../data/model/contact_model.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRTL = sl<CacheHelper>().getCachedLanguage() == 'ar';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            SizedBox(width: 12.w),

            // Contact Info - Expanded to take available space
            Expanded(
              child: _buildContactInfo(isRTL),
            ),
            SizedBox(width: 12.w),

            _buildAddButton(context, isRTL),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF0F2F9),
      ),
      alignment: Alignment.center,
      child: Text(
        contact.initial ?? contact.name.substring(0, 1),
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildContactInfo(bool isRTL) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          contact.name,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          contact.phone,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context, bool isRTL) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(
              minWidth: 80.w,
              maxWidth: availableWidth * 0.3, // Limit to 30% of available width
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            height: 36.h,
            decoration: BoxDecoration(
              color: contact.isSelected ? AppColors.green : AppColors.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Icon(
                    contact.isSelected
                        ? CupertinoIcons.person_crop_circle_fill_badge_checkmark
                        : CupertinoIcons.person_add_solid,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    contact.isSelected
                        ? 'added'.tr(context)
                        : 'add'.tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
