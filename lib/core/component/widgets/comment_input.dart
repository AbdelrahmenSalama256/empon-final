import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool isLoading;
  final FocusNode? focusNode; // Added for keyboard management

  const CommentInput({
    super.key,
    required this.controller,
    this.onSubmit,
    this.isLoading = false,
    this.focusNode,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
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
                if (value.isNotEmpty && widget.onSubmit != null) {
                  widget.onSubmit!();
                  FocusScope.of(context).unfocus(); // Hide keyboard
                }
              },
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 15.w),
                  SizedBox(
                    width: 100.w,
                    child: AppButton(
                      borderRadius: BorderRadius.circular(5.r),
                      height: 40.h,
                      width: 61.w,
                      isLoading: widget.isLoading,
                      backgroundColor: widget.controller.text.isEmpty
                          ? const Color(0xffBDBDBD)
                          : AppColors.primary,
                      onPressed: () {
                        if (widget.controller.text.isNotEmpty &&
                            widget.onSubmit != null) {
                          widget.onSubmit!();
                          FocusScope.of(context).unfocus(); // Hide keyboard
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
