import 'package:flutter/material.dart';
import 'package:embone/core/constants/app_colors.dart';

void showToast(
  BuildContext context, {
  required String message,
  required ToastStates state,
  Duration duration = const Duration(seconds: 3),
}) {
  // Ensure any existing SnackBar is removed before showing a new one
  ScaffoldMessenger.of(context).removeCurrentSnackBar();

  // Show a SnackBar with the message and style based on the state
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: chooseToastColor(state),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    ),
  );
}

enum ToastStates {
  success,
  error,
  warning,
}

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = AppColors.primaryColor;
      break;
    case ToastStates.error:
      color = AppColors.red;
      break;
    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}
