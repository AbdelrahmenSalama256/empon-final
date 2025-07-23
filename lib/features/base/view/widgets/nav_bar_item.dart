import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/constants/app_colors.dart';

PersistentBottomNavBarItem buildNavBarItem({
  required BuildContext context,
  required String iconPath,
  required String labelKey,
  bool isCenterItem = false,
  double iconSize = 24.0,
  double widthFactor = 1.0,
  Color activeColor = const Color(0xFF1565C0),
  Color inactiveColor = const Color(0xFF9DB2CE),
  int unreadCount = 0,
}) {
  if (isCenterItem) {
    return PersistentBottomNavBarItem(
      icon: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 50.w,
            height: 50.h,
            colorFilter: ColorFilter.mode(
              activeColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      inactiveIcon: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 50.w,
            height: 50.h,
          ),
        ),
      ),
      title: '',
      activeColorPrimary: Colors.transparent,
      inactiveColorPrimary: Colors.white,
    );
  } else {
    return PersistentBottomNavBarItem(
      icon: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: labelKey == 'nav_menu'
                    ? EdgeInsets.all(4.w)
                    : EdgeInsets.zero,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    activeColor,
                    BlendMode.srcIn,
                  ),
                  height: iconSize.h,
                  width: iconSize.w,
                ),
              ),
              if (labelKey.isNotEmpty) SizedBox(height: 2.h),
              if (labelKey.isNotEmpty)
                Text(
                  labelKey.tr(context),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: activeColor,
                        fontSize: 10.sp,
                      ),
                ),
            ],
          ),
          if (labelKey == 'nav_notification' && unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
      inactiveIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: labelKey == 'nav_menu'
                    ? EdgeInsets.all(4.w)
                    : EdgeInsets.zero,
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    inactiveColor,
                    BlendMode.srcIn,
                  ),
                  height: iconSize.h,
                  width: iconSize.w,
                ),
              ),
            ],
          ),
          if (labelKey == 'nav_notification' && unreadCount > 0)
            PositionedDirectional(
              start: -5.w,
              top: 10.h,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
      activeColorPrimary: activeColor,
      inactiveColorPrimary: inactiveColor,
    );
  }
}
