import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;

  const CommentInput({
    super.key,
    required this.controller,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          // Comment input field
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'write_comment_here'.tr(context),
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0.h,
                  horizontal: 7.w,
                ),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                if (value.isNotEmpty && onSubmit != null) {
                  onSubmit!();
                  controller.clear();
                }
              },
            ),
          ),
          // Action buttons area with gray background
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Emoji button
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.emoji_emotions_outlined,
                  //     color: Colors.grey.shade600,
                  //     size: 24.w,
                  //   ),
                  //   padding: EdgeInsets.zero,
                  //   constraints: BoxConstraints(
                  //     minWidth: 24.w,
                  //     minHeight: 24.h,
                  //   ),
                  //   onPressed: () {
                  //     // TODO: Implement emoji picker
                  //   },
                  // ),
                  SizedBox(width: 15.w),
                  // Send button
                  SizedBox(
                    width: 100.w,
                    child: AppButton(
                      borderRadius: BorderRadius.circular(5.r),
                      height: 40.h,
                      width: 61.w,
                      backgroundColor: const Color(0xffBDBDBD),
                      onPressed: () {
                        if (controller.text.isNotEmpty && onSubmit != null) {
                          onSubmit!();
                          controller.clear();
                        }
                      },
                      text: 'send'.tr(context),
                      textStyle: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
