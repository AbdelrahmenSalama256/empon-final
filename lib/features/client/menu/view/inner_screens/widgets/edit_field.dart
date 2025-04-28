import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditableAppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final IconData prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function() onEditPressed;

  const EditableAppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.keyboardType,
    required this.textInputAction,
    required this.prefixIcon,
    this.inputFormatters,
    this.validator,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          labelText.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          ),
        ),

        SizedBox(height: 8.h),

        // Read-only field with edit icon
        GestureDetector(
          onTap: onEditPressed,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FB),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                // Prefix icon
                Icon(
                  prefixIcon,
                  size: 20.w,
                  // ignore: deprecated_member_use
                  color: const Color(0xff8F95AB).withOpacity(0.7),
                ),

                SizedBox(width: 12.w),

                // Text field (read-only in main view)
                Expanded(
                  child: Text(
                    controller.text,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                ),

                // Edit icon
                Icon(Icons.edit, size: 20.w, color: Colors.blue),
              ],
            ),
          ),
        ),

        // Validation error message (if any)
        if (validator != null && validator!(controller.text) != null)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: Text(
              validator!(controller.text)!,
              style: TextStyle(fontSize: 12.sp, color: Colors.red),
            ),
          ),
      ],
    );
  }
}
