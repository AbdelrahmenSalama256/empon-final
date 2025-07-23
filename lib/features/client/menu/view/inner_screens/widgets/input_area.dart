import 'dart:io';

import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';
import '../../cubit/cubit/supportchat_cubit.dart';

class InputArea extends StatelessWidget {
  final TextEditingController messageController;
  final Function() onPickFile;
  final Function(SupportchatCubit cubit) onSendMessage;
  final File? selectedFile;

  const InputArea({
    super.key,
    required this.messageController,
    required this.onPickFile,
    required this.onSendMessage,
    this.selectedFile,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupportchatCubit>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: "type_your_message".tr(context),
                hintStyle: const TextStyle(color: AppColors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.h,
                ),
              ),
              style: TextStyle(fontSize: 16.sp, color: AppColors.grey),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              onSubmitted: (_) => onSendMessage(cubit),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onPickFile,
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AppColors.grey.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.attach_file,
                color: AppColors.grey,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => onSendMessage(cubit),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: AppColors.white,
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
