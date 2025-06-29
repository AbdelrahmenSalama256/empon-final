import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HeaderAlignment { left, center, right, spaceBetween }

enum HeaderStyle { standard, transparent, elevated }

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
  final MainAxisAlignment leadingPosition;

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
    this.leadingPosition = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";
    final canPop = Navigator.of(context).canPop();
    final shouldShowBackButton = showBackButton ||
        (automaticallyImplyLeading && canPop && leading == null);

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
            Icons.arrow_back_rounded,
            size: 20.h,
            color: AppColors.black,
          ),
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      );
    }

    Widget? titleContent = titleWidget ??
        (showLogo
            ? Image.asset(
                logoPath,
                height: logoHeight ?? 32.h,
                width: logoWidth ?? 118.w,
                fit: BoxFit.contain,
              )
            : (title != null
                ? Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: titleStyle ??
                        TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                          height: 2.h,
                        ),
                    // overflow: TextOverflow.ellipsis,
                  )
                : null));

    BoxDecoration? decoration = style == HeaderStyle.elevated
        ? BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: elevation ?? 4,
                offset: const Offset(0, 2),
              ),
            ],
          )
        : BoxDecoration(
            color: style == HeaderStyle.transparent
                ? Colors.transparent
                : backgroundColor,
          );

    Widget content = Row(
      mainAxisAlignment: alignment == HeaderAlignment.center
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (leadingWidget != null && leadingPosition == MainAxisAlignment.start)
          leadingWidget,

        if (titleContent != null) ...[
          if (centerTitle)
            Expanded(
              child: actions != null
                  ? Center(child: titleContent)
                  : Row(
                      children: [
                        const Spacer(
                          flex: 1,
                        ),
                        Center(child: titleContent),
                        const Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
            )
          else
            Expanded(
              child: Align(
                alignment: isRTL
                    ? AlignmentDirectional.centerStart
                    : AlignmentDirectional.centerEnd,
                child: titleContent,
              ),
            ),
        ] else
          const Spacer(),

        // Actions on the right
        if (actions != null && actions!.isNotEmpty)
          Row(mainAxisSize: MainAxisSize.min, children: actions!),

        // Leading widget on the right (if positioned there)
        if (leadingWidget != null && leadingPosition == MainAxisAlignment.end)
          leadingWidget,
      ],
    );
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
}
