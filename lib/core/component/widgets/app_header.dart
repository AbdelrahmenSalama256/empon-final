import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HeaderAlignment {
  left,
  center,
  right,
  spaceBetween,
}

enum HeaderStyle {
  standard,
  transparent,
  elevated,
}

class AppHeader extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool showLogo;
  final String logoPath;
  final double? logoHeight;
  final double? logoWidth;
  final Color backgroundColor;
  final double? height;
  final EdgeInsetsGeometry padding;
  final HeaderAlignment alignment;
  final HeaderStyle style;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final Widget? bottom;
  final double? elevation;
  final bool automaticallyImplyLeading;

  const AppHeader({
    super.key,
    this.title,
    this.titleStyle,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.showLogo = false,
    this.logoPath = 'assets/images/logo_text.png',
    this.logoHeight,
    this.logoWidth,
    this.backgroundColor = AppColors.white,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.alignment = HeaderAlignment.spaceBetween,
    this.style = HeaderStyle.standard,
    this.onBackPressed,
    this.centerTitle = false,
    this.bottom,
    this.elevation,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Determine if we should show a back button based on navigation stack
    final canPop = Navigator.of(context).canPop();
    final shouldShowBackButton = showBackButton ||
        (automaticallyImplyLeading && canPop && leading == null);

    // Build the leading widget (back button or custom leading)
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (shouldShowBackButton) {
      leadingWidget = IconButton(
        icon: Container(
          width: 35.w,
          height: 35.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.h),
            border: Border.all(color: AppColors.grey, width: 0.2.w),
          ),
          child: Icon(
            isRTL ? CupertinoIcons.arrow_right : CupertinoIcons.arrow_left,
            size: 20.h,
            color: AppColors.black,
          ),
        ),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    // Build the title widget
    Widget? titleContent;
    if (titleWidget != null) {
      titleContent = titleWidget;
    } else if (showLogo) {
      titleContent = Image.asset(
        logoPath,
        height: logoHeight ?? 32.h,
        width: logoWidth ?? 118.w,
        fit: BoxFit.contain,
      );
    } else if (title != null) {
      titleContent = Text(
        title!,
        style: titleStyle ??
            TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
        overflow: TextOverflow.ellipsis,
      );
    }

    // Apply container styling based on header style
    BoxDecoration? decoration;
    if (style == HeaderStyle.elevated) {
      decoration = BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: elevation ?? 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
    } else {
      decoration = BoxDecoration(
        color: style == HeaderStyle.transparent
            ? Colors.transparent
            : backgroundColor,
      );
    }

    // Build the main content based on alignment
    Widget content;
    switch (alignment) {
      case HeaderAlignment.left:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: _buildRowChildren(leadingWidget, titleContent, actions),
        );
        break;
      case HeaderAlignment.center:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildRowChildren(leadingWidget, titleContent, actions),
        );
        break;
      case HeaderAlignment.right:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: _buildRowChildren(leadingWidget, titleContent, actions),
        );
        break;
      case HeaderAlignment.spaceBetween:
      default:
        content = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Leading section (back button or custom leading)
            leadingWidget ?? const SizedBox(width: 40),

            // Title/Logo section
            if (centerTitle)
              Expanded(
                child: Center(
                  child: titleContent ?? const SizedBox(),
                ),
              )
            else
              titleContent ?? const SizedBox(),

            // Actions section
            if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              )
            else
              const SizedBox(width: 40),
          ],
        );
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: height,
          padding: padding,
          decoration: decoration,
          child: content,
        ),
        if (bottom != null) bottom!,
      ],
    );
  }

  List<Widget> _buildRowChildren(
      Widget? leadingWidget, Widget? titleContent, List<Widget>? actions) {
    final List<Widget> children = [];

    if (leadingWidget != null) {
      children.add(leadingWidget);
    }

    if (titleContent != null) {
      if (centerTitle && children.isNotEmpty) {
        children.add(Expanded(
          child: Center(child: titleContent),
        ));
      } else {
        children.add(titleContent);
      }
    }

    if (actions != null && actions.isNotEmpty) {
      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: actions,
        ),
      );
    }

    return children;
  }
}
