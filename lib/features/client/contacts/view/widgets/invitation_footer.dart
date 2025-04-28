import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/component/widgets/app_button.dart';
import '../../../../../core/constants/app_colors.dart';

class InvitationFooter extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSendPressed;
  final VoidCallback onDonePressed;

  const InvitationFooter({
    super.key,
    required this.isLoading,
    required this.onSendPressed,
    required this.onDonePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title and Send Button
          _buildSendInvitationRow(context),
          SizedBox(height: 16.h),

          // Done Button
          _buildDoneButton(context),
        ],
      ),
    );
  }

  Widget _buildSendInvitationRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            'send_invite'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
        SizedBox(width: 16.w),
        const Spacer(),
        AppButton(
          text: 'send'.tr(context),
          onPressed: onSendPressed,
          isLoading: isLoading,
          isFullWidth: false,
          width: 100.w,
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
          height: 28.h,
          borderRadius: BorderRadius.circular(8.r),
          suffixIcon: Icon(
            CupertinoIcons.person_2_fill,
            color: Colors.white,
            size: 20.w,
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onDonePressed,
          borderRadius: BorderRadius.circular(12.r),
          child: Center(
            child: Text(
              'done'.tr(context),
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
