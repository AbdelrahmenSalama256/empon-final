import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

BottomNavigationBarItem buildNavBarItem({
  required BuildContext context,
  required String iconPath,
  required String labelKey,
  bool isCenterItem = false,
  double iconSize = 24.0,
  double widthFactor = 1.0,
  Color activeColor = const Color(0xFF1565C0),
  Color inactiveColor = const Color(0xFF9DB2CE),
}) {
  if (isCenterItem) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 60.w,
        height: 60.h,
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
      activeIcon: Container(
        width: 60.w,
        height: 60.h,
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
      label: labelKey.isNotEmpty
          ? labelKey.tr(context)
          : ' ', // Ensure non-null label
    );
  } else {
    return BottomNavigationBarItem(
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                labelKey == 'nav_menu' ? EdgeInsets.all(4.w) : EdgeInsets.zero,
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
      activeIcon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                labelKey == 'nav_menu' ? EdgeInsets.all(4.w) : EdgeInsets.zero,
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
        ],
      ),
      label: labelKey.isNotEmpty
          ? labelKey.tr(context)
          : ' ', // Ensure non-null label
    );
  }
}
