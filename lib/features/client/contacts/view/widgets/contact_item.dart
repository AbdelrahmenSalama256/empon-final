import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/network/local_network.dart';
import '../../../../../core/services/service_locator.dart';
import '../../data/model/contact_model.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel contact;
  final VoidCallback onTap;
  final bool isRegistered;

  const ContactListItem({
    super.key,
    required this.contact,
    required this.onTap,
    this.isRegistered = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRTL = sl<CacheHelper>().getCachedLanguage() == 'ar';

    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        // box-shadow: 0px 10px 70px 0px #1D22610F; in Flutter
        boxShadow: [
          BoxShadow(
            color: const Color(0x1D22610F),
            offset: Offset(0, 10.h),
            blurRadius: 70.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 12.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Avatar
                  _buildAvatar(),
                  SizedBox(width: 12.w),

                  Flexible(
                    child: _buildContactInfo(isRTL),
                  ),
                ],
              ),
            ),
            _buildActionButton(context, isRTL),

            // SizedBox(width: 12.w),
            // const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 50.w,
      height: 50.w,
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

  Widget _buildActionButton(BuildContext context, bool isRTL) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        String buttonText;
        IconData icon;
        Color color;

        if (isRegistered) {
          final status =
              context.read<FriendsCubit>().getFriendRequestStatus(contact.id);
          if (status == "pending") {
            buttonText = 'added';
            icon = CupertinoIcons.hourglass;
            color = AppColors.green;
          } else if (status == "accepted") {
            buttonText = 'added';
            icon = CupertinoIcons.person_crop_circle_fill_badge_checkmark;
            color = AppColors.green;
          } else {
            buttonText = 'add';
            icon = CupertinoIcons.person_add_solid;
            color = AppColors.primary;
          }
        } else {
          buttonText = 'invite';
          icon = CupertinoIcons.share;
          color = AppColors.gradientFour;
        }

        return GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(
              minWidth: 80.w,
              maxWidth: availableWidth * 0.3,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            height: 36.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    buttonText.tr(context),
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
