// ignore_for_file: deprecated_member_use

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionButton extends StatefulWidget {
  final String icon;
  final String? activeIcon;
  final String label;
  final VoidCallback onPressed;
  final bool isActive; // Initial state (e.g., isLiked or isFavorite)
  final Color activeBackgroundColor; // Background when active
  final Color inactiveBackgroundColor; // Background when inactive

  const ActionButton({
    super.key,
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.onPressed,
    this.isActive = false,
    this.activeBackgroundColor = AppColors.white,
    this.inactiveBackgroundColor = AppColors.primary,
  });

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  @override
  void didUpdateWidget(covariant ActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _isActive = widget.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isActive = !_isActive;
          });
          widget.onPressed();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: _isActive
                ? widget.activeBackgroundColor
                : widget.inactiveBackgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(3.w, 3.h),
                blurRadius: 6.r,
                spreadRadius: 1.r,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                offset: Offset(-2.w, -2.h),
                blurRadius: 4.r,
                spreadRadius: 0.5.r,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label.tr(context),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: _isActive ? AppColors.primary : Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 5.w),
              SvgPicture.asset(
                _isActive && widget.activeIcon != null
                    ? widget.activeIcon!
                    : widget.icon,
                color: _isActive ? AppColors.primary : Colors.white,
                width: 15.w,
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
