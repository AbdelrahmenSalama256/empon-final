import 'package:embone/core/component/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ApprovalStatus {
  pending,
  approved,
  rejected,
  processing,
}

class ApprovalItem extends StatelessWidget {
  final String title;
  final ApprovalStatus status;
  final VoidCallback? onApprove;
  final String approveButtonText;
  final Widget? icon;
  final bool showApproveButton;
  final Color? approveButtonColor;
  final Color? pendingColor;
  final Color? approvedColor;
  final Color? rejectedColor;
  final Color? processingColor;
  final bool? isLoading;

  const ApprovalItem({
    super.key,
    required this.title,
    this.status = ApprovalStatus.pending,
    this.onApprove,
    this.approveButtonText = 'اعتمده هنا',
    this.showApproveButton = true,
    this.approveButtonColor,
    this.pendingColor,
    this.icon,
    this.approvedColor,
    this.rejectedColor,
    this.processingColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Status icon
          if (icon != null) icon!,
          if (icon != null) SizedBox(width: 12.w),
          // SizedBox(width: 12.w),
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),

          if (showApproveButton)
            Expanded(
              child: AppButton(
                onPressed: onApprove,
                text: approveButtonText,
                backgroundColor: approveButtonColor,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                height: 30.h,
                borderRadius: BorderRadius.circular(8.r),
                textStyle: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
                isLoading: isLoading ?? false,
              ),
            ),
        ],
      ),
    );
  }
}
