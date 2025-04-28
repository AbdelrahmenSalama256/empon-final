import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: Colors.white,
      child: Row(
        children: [
          // Send Button
          Transform.rotate(
            angle: 3.14159,
            child: Icon(Icons.send, color: AppColors.primary, size: 24.sp),
          ),

          SizedBox(width: 12.w),

          // Message Input Field
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    //
                    // decoration: InputDecoration(
                    textInputAction: TextInputAction.send,
                    hintText: 'write_massage_here'.tr(context),
                    controller: TextEditingController(),
                    suffixIcon:
                        Icon(Icons.add, color: Colors.grey[400], size: 24.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
