import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PopupType {
  alert,
  success,
  error,
  delete,
  custom,
}

class CustomPopupConfig {
  // Icon configuration
  final double? iconSize;
  final double? iconContainerSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final IconData? iconData;
  final BorderRadius? iconBorderRadius;
  final BoxBorder? iconBorder;
  final EdgeInsetsGeometry? iconPadding;
  final BoxShape iconShape;

  // Button configuration
  final double? buttonHeight;
  final BorderRadius? buttonBorderRadius;
  final EdgeInsetsGeometry? buttonPadding;
  final TextStyle? buttonTextStyle;

  const CustomPopupConfig({
    this.iconSize,
    this.iconContainerSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconData,
    this.iconBorderRadius,
    this.iconBorder,
    this.iconPadding,
    this.iconShape = BoxShape.circle,
    this.buttonHeight,
    this.buttonBorderRadius,
    this.buttonPadding,
    this.buttonTextStyle,
  });
}

class CustomPopup extends StatelessWidget {
  final PopupType type;
  final String title;
  final String? message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;
  final VoidCallback? onDismiss;
  final Widget? customContent;
  final Color? primaryButtonColor;
  final Color? secondaryButtonColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? backgroundColor;
  final Widget? icon;
  final bool barrierDismissible;
  final CustomPopupConfig? config;
  final bool useCustomButtons; // Flag to use custom AppButton
  final bool useCustomIconAppearance; // Flag to use custom icon appearance

  const CustomPopup({
    super.key,
    required this.type,
    required this.title,
    this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
    this.onDismiss,
    this.customContent,
    this.primaryButtonColor,
    this.secondaryButtonColor,
    this.titleColor,
    this.messageColor,
    this.backgroundColor,
    this.icon,
    this.barrierDismissible = true,
    this.config,
    this.useCustomButtons = false, // Default to false
    this.useCustomIconAppearance = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.r)),
      backgroundColor: backgroundColor ?? Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon based on type
            if (type != PopupType.custom && icon == null) _buildIcon(),
            if (icon != null) icon!,

            SizedBox(height: icon == null ? 0.h : 16.h),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: _getTitleColor(),
              ),
            ),

            // Message
            if (message != null) ...[
              SizedBox(height: 10.h),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: messageColor ?? const Color(0xff7F7F7F),
                ),
              ),
            ],

            // Custom Content
            if (customContent != null) ...[
              SizedBox(height: 16.h),
              customContent!,
            ],

            SizedBox(height: 24.h),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (secondaryButtonText != null && primaryButtonText != null)
                  SizedBox(width: 12.w),
                if (primaryButtonText != null)
                  Expanded(child: _buildPrimaryButton(context)),
                SizedBox(width: 12.w),
                if (secondaryButtonText != null)
                  Expanded(child: _buildSecondaryButton(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // If using default icon appearance and not custom type
    if (!useCustomIconAppearance) {
      switch (type) {
        case PopupType.success:
          return SizedBox(
            width: 100.w,
            height: 100.h,
            child: Image.asset(
              "assets/images/success.png",
              // color: Colors.white,
              width: 100.w,
              height: 100.h,
            ),
          );
        case PopupType.error:
        case PopupType.delete:
        case PopupType.alert:
        default:
          return const SizedBox.shrink();
      }
    }

    // Using custom icon appearance
    final iconSize = config?.iconSize ?? 40.w;
    final containerSize = config?.iconContainerSize ?? 60.w;
    final iconPadding = config?.iconPadding;
    final iconShape = config?.iconShape ?? BoxShape.circle;
    final iconBorderRadius = config?.iconBorderRadius;
    final iconBorder = config?.iconBorder;

    IconData iconData;
    Color iconColor;
    Color backgroundColor;

    switch (type) {
      case PopupType.success:
        iconData = config?.iconData ?? Icons.check;
        iconColor = config?.iconColor ?? Colors.white;
        backgroundColor = config?.iconBackgroundColor ?? AppColors.primary;
        break;
      case PopupType.error:
        iconData = config?.iconData ?? Icons.close;
        iconColor = config?.iconColor ?? Colors.white;
        backgroundColor = config?.iconBackgroundColor ?? Colors.red;
        break;
      case PopupType.delete:
        iconData = config?.iconData ?? Icons.delete_outline;
        iconColor = config?.iconColor ?? Colors.red;
        backgroundColor = config?.iconBackgroundColor ?? Colors.red.shade50;
        break;
      case PopupType.alert:
      default:
        iconData = config?.iconData ?? Icons.warning_amber_rounded;
        iconColor = config?.iconColor ?? Colors.orange;
        backgroundColor = config?.iconBackgroundColor ?? Colors.orange.shade50;
        break;
    }

    return Container(
      width: containerSize,
      height: containerSize,
      padding: iconPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: iconShape,
        borderRadius: iconShape == BoxShape.rectangle
            ? (iconBorderRadius ?? BorderRadius.circular(12.r))
            : null,
        border: iconBorder,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: iconSize,
      ),
    );
  }

  Color _getTitleColor() {
    if (titleColor != null) return titleColor!;

    switch (type) {
      case PopupType.delete:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  Widget _buildPrimaryButton(BuildContext context) {
    final buttonColor = _getPrimaryButtonColor();

    // Use custom AppButton if flag is true
    if (useCustomButtons) {
      final buttonHeight = config?.buttonHeight ?? 45.h;
      final buttonBorderRadius =
          config?.buttonBorderRadius ?? BorderRadius.circular(8.r);
      final buttonPadding = config?.buttonPadding;
      final buttonTextStyle = config?.buttonTextStyle;

      return AppButton(
        text: primaryButtonText ?? 'ok'.tr(context),
        onPressed: onPrimaryButtonPressed ?? () => Navigator.of(context).pop(),
        type: AppButtonType.primary,
        height: buttonHeight,
        backgroundColor: buttonColor,
        borderRadius: buttonBorderRadius,
        padding: buttonPadding,
        textStyle: buttonTextStyle ??
            TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      );
    }
    final buttonHeight = config?.buttonHeight ?? 45.h;
    final buttonBorderRadius =
        config?.buttonBorderRadius ?? BorderRadius.circular(8.r);
    final buttonPadding = config?.buttonPadding;
    final buttonTextStyle = config?.buttonTextStyle;

    // Use default ElevatedButton
    return AppButton(
      onPressed: onPrimaryButtonPressed ?? () => Navigator.of(context).pop(),
      text: primaryButtonText ?? 'ok'.tr(context),
      height: buttonHeight,
      backgroundColor: buttonColor,
      borderRadius: buttonBorderRadius,
      padding: buttonPadding,
      textStyle: buttonTextStyle ??
          TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final buttonColor = _getSecondaryButtonColor();

    // Use custom AppButton if flag is true
    if (useCustomButtons) {
      final buttonHeight = config?.buttonHeight ?? 45.h;
      // final buttonBorderRadius =
      //     config?.buttonBorderRadius ?? BorderRadius.circular(8.r);
      final buttonPadding = config?.buttonPadding;
      final buttonTextStyle = config?.buttonTextStyle;

      return AppButton(
        text: secondaryButtonText ?? 'Cancel',
        onPressed:
            onSecondaryButtonPressed ?? () => Navigator.of(context).pop(),
        type: AppButtonType.secondary,
        height: buttonHeight,
        borderColor: buttonColor,
        padding: buttonPadding,
        textStyle: buttonTextStyle ??
            TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: buttonColor,
            ),
      );
    }

    // Use default OutlinedButton
    return OutlinedButton(
      onPressed: onSecondaryButtonPressed ?? () => Navigator.of(context).pop(),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: buttonColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        minimumSize: Size(0, 45.h),
      ),
      child: Text(
        secondaryButtonText ?? 'cancel'.tr(context),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: buttonColor,
        ),
      ),
    );
  }

  Color _getPrimaryButtonColor() {
    if (primaryButtonColor != null) return primaryButtonColor!;

    switch (type) {
      case PopupType.delete:
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  Color _getSecondaryButtonColor() {
    if (secondaryButtonColor != null) return secondaryButtonColor!;

    switch (type) {
      case PopupType.delete:
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  // Show popup method
  static Future<T?> show<T>({
    required BuildContext context,
    required PopupType type,
    required String title,
    String? message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryButtonPressed,
    VoidCallback? onSecondaryButtonPressed,
    VoidCallback? onDismiss,
    Widget? customContent,
    Color? primaryButtonColor,
    Color? secondaryButtonColor,
    Color? titleColor,
    Color? messageColor,
    Color? backgroundColor,
    Widget? icon,
    bool barrierDismissible = true,
    CustomPopupConfig? config,
    bool useCustomButtons = false,
    bool useCustomIconAppearance = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => CustomPopup(
        type: type,
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryButtonPressed: onPrimaryButtonPressed,
        onSecondaryButtonPressed: onSecondaryButtonPressed,
        onDismiss: onDismiss,
        customContent: customContent,
        primaryButtonColor: primaryButtonColor,
        secondaryButtonColor: secondaryButtonColor,
        titleColor: titleColor,
        messageColor: messageColor,
        backgroundColor: backgroundColor,
        icon: icon,
        barrierDismissible: barrierDismissible,
        config: config,
        useCustomButtons: useCustomButtons,
        useCustomIconAppearance: useCustomIconAppearance,
      ),
    );
  }
}
