import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;
  final String? Function(String?)? validator;
  final String dateFormat;

  const AppDatePicker({
    super.key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
    this.dateFormat = 'yyyy-MM-dd',
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      readOnly: true,
      validator: validator,
      suffixIcon:
          const Icon(Icons.calendar_today, color: AppColors.textSecondary),
      onTap: () => _selectDate(context),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDateTime = initialDate ?? now;
    final DateTime firstDateTime = firstDate ?? DateTime(now.year - 100);
    final DateTime lastDateTime = lastDate ?? DateTime(now.year + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDateTime,
      firstDate: firstDateTime,
      lastDate: lastDateTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat(dateFormat).format(picked);
      controller.text = formattedDate;
      if (onDateSelected != null) {
        onDateSelected!(picked);
      }
    }
  }
}
