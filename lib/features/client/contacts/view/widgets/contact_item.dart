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
        boxShadow: [
          BoxShadow(
            color: const Color(0x1D22610F),
            offset: Offset(0, 10.h),
            blurRadius: 70.r,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildAvatar(),
                  SizedBox(width: 12.w),
                  Flexible(child: _buildContactInfo(isRTL)),
                ],
              ),
            ),
            _buildActionButton(context, isRTL),
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
        contact.initial ??
            (contact.name.isNotEmpty ? contact.name.substring(0, 1) : ''),
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
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
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
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isRTL) {
    final double buttonWidth = isRegistered ? 100.w : 80.w;

    return SizedBox(
      width: buttonWidth,
      child: _ButtonContent(
        contact: contact,
        isRegistered: isRegistered,
        onTap: onTap,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final ContactModel contact;
  final bool isRegistered;
  final VoidCallback onTap;

  const _ButtonContent({
    required this.contact,
    required this.isRegistered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final friendsCubit = context.read<FriendsCubit>();
    final status = friendsCubit.getFriendRequestStatus(contact.id);

    // Determine button state based on API response
    final isFriend = contact.isFriend == true;
    final isPending = friendsCubit.nonRegisteredContacts == "pending";
    final isAccepted = status == "accepted";

    String buttonText;
    IconData icon;
    Color color;

    if (isRegistered) {
      if (isFriend) {
        buttonText = 'delete';
        icon = CupertinoIcons.trash;
        color = AppColors.red;
      } else if (contact.status == 'pending' || isPending) {
        buttonText = 'pending';
        icon = CupertinoIcons.hourglass;
        color = AppColors.orange;
      } else if (contact.status == 'accepted' || isAccepted) {
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
      child: Container(
        height: 36.h,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16.w),
            SizedBox(width: 4.w),
            Text(
              buttonText.tr(context),
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
