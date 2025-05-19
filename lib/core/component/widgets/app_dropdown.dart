import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownField extends StatelessWidget {
  final String hint;
  final String? value; // Used for single-select
  final List<String>? selectedValues; // Used for multi-select
  final List<String> items;
  final ValueChanged<String?> onChanged; // Callback for single-select
  final ValueChanged<List<String>>?
      onMultipleChanged; // Callback for multi-select
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
  final bool isMultiSelect;

  const AppDropdownField({
    super.key,
    required this.hint,
    this.value,
    this.selectedValues,
    required this.items,
    required this.onChanged,
    this.onMultipleChanged,
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
    this.isMultiSelect = false,
  }) : assert((isMultiSelect && onMultipleChanged != null) || (!isMultiSelect),
            'For multiSelect=true, provide onMultipleChanged. For multiSelect=false, provide onChanged.');

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
          border: showErrorBorder &&
                  (isMultiSelect
                      ? (selectedValues == null || selectedValues!.isEmpty) &&
                          validator?.call('') != null
                      : validator?.call(value) != null)
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

            // Text or Chips Content
            Expanded(
              child: _buildDisplayContent(context),
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

  /// Builds the display content (chips for multi-select, text for single-select).
  Widget _buildDisplayContent(BuildContext context) {
    if (isMultiSelect) {
      if (selectedValues == null || selectedValues!.isEmpty) {
        return Text(
          hint,
          style: _getDisplayStyle(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        );
      }
      return Wrap(
        spacing: 8.w,
        runSpacing: 4.h,
        children: selectedValues!.map((item) {
          return Chip(
            label: Text(
              item,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.primary,
            deleteIcon: Icon(
              Icons.close,
              size: 16.w,
              color: Colors.white,
            ),
            onDeleted: enabled
                ? () {
                    final updatedValues = List<String>.from(selectedValues!);
                    updatedValues.remove(item);
                    onMultipleChanged!(updatedValues);
                  }
                : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          );
        }).toList(),
      );
    } else {
      return Text(
        value?.isNotEmpty == true ? value! : hint,
        style: _getDisplayStyle(),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
  }

  /// Returns the style for the displayed text (used for hint or single-select).
  TextStyle _getDisplayStyle() {
    final bool hasValue = isMultiSelect
        ? (selectedValues != null && selectedValues!.isNotEmpty)
        : (value?.isNotEmpty == true);

    return hasValue
        ? selectedTextStyle ??
            TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff8F95AB),
            )
        : hintStyle ??
            TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff8F95AB).withAlpha((0.7 * 255).toInt()),
            );
  }

  /// Shows the appropriate bottom sheet based on selection mode.
  void _showDropdownBottomSheet(BuildContext context) {
    PrintUtil.info("Opening dropdown bottom sheet for: $hint");

    if (isMultiSelect) {
      _showMultiSelectBottomSheet(context);
    } else {
      _showSingleSelectBottomSheet(context);
    }
  }

  /// Displays a bottom sheet for single-select mode.
  void _showSingleSelectBottomSheet(BuildContext context) {
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

  /// Displays a bottom sheet for multi-select mode.
  void _showMultiSelectBottomSheet(BuildContext context) {
    // Create a temporary list to hold selections
    List<String> tempSelectedValues = List.from(selectedValues ?? []);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hint,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          PrintUtil.info(
                              "Multi-select confirmed: $tempSelectedValues");
                          onMultipleChanged!(tempSelectedValues);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'done'.tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
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
                      final isSelected = tempSelectedValues.contains(item);

                      return CheckboxListTile(
                        title: Text(
                          item,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        value: isSelected,
                        activeColor: AppColors.primary,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              tempSelectedValues.add(item);
                            } else {
                              tempSelectedValues.remove(item);
                            }
                            PrintUtil.info(
                                "Multi-select updated: $tempSelectedValues");
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
