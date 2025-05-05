import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';

class AppDropdownField extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;
  final bool showErrorBorder;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? dropdownIconSize;
  final Color? dropdownIconColor;
  final TextStyle? hintStyle;
  final TextStyle? selectedTextStyle;
  final bool enabled;

  const AppDropdownField({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.showErrorBorder = false,
    this.prefixIcon,
    this.suffixIcon,
    this.contentPadding,
    this.dropdownIconSize,
    this.dropdownIconColor,
    this.hintStyle,
    this.selectedTextStyle,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _showDropdownBottomSheet(context) : null,
      child: Container(
        padding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 10.h,
            ),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xffF0F2F9) : const Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(15.r),
          border: showErrorBorder && validator?.call(value) != null
              ? Border.all(color: AppColors.error, width: 1.0)
              : null,
        ),
        child: Row(
          children: [
            // Prefix Icon
            if (prefixIcon != null) ...[
              prefixIcon!,
              SizedBox(width: 0.w),
            ],

            // Text Content
            Expanded(
              child: Text(
                value?.isNotEmpty == true ? value! : hint,
                style: value?.isNotEmpty != true
                    ? hintStyle ??
                        TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8F95AB)
                              .withAlpha((0.7 * 255).toInt()),
                        )
                    : selectedTextStyle ??
                        TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8F95AB),
                        ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Suffix Icon (custom or default dropdown icon)
            if (suffixIcon != null) ...[
              SizedBox(width: 12.w),
              suffixIcon!,
            ] else ...[
              SizedBox(width: 8.w),
              Container(
                width: 25.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: enabled ? Colors.white : const Color(0xffE0E0E0),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: enabled
                      ? (dropdownIconColor ?? AppColors.black)
                      : Colors.grey,
                  size: dropdownIconSize ?? 24.w,
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ],
        ),
      ),
    );
  }

  void _showDropdownBottomSheet(BuildContext context) {
    PrintUtil.info("Opening dropdown bottom sheet for: $hint");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                hint,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Divider(height: 1.h),
            SizedBox(
              height: items.length > 5 ? 300.h : null,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    trailing: value == item
                        ? Icon(Icons.check,
                            color: AppColors.primary, size: 24.w)
                        : null,
                    onTap: () {
                      PrintUtil.info("Selected item: $item");
                      onChanged(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
