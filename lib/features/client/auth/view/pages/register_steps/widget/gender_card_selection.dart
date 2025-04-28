import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderSelectionCard extends StatelessWidget {
  final Gender selectedGender;
  final Function(Gender) onGenderChanged;

  const GenderSelectionCard({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F2F9),
        borderRadius: BorderRadius.circular(12.r), // Responsive radius
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: 12.h, horizontal: 16.w), // Responsive padding
        child: Column(
          children: [
            _buildGenderOption(
              context,
              Gender.male,
              'male'.tr(context),
              'assets/images/svg/male.svg',
              isRTL,
            ),
            SizedBox(height: 12.h), // Responsive spacing
            _buildGenderOption(
              context,
              Gender.female,
              'female'.tr(context),
              'assets/images/svg/female.svg',
              isRTL,
            ),
            SizedBox(height: 12.h), // Responsive spacing
            _buildGenderOption(
              context,
              Gender.other,
              'other'.tr(context),
              'assets/images/svg/others.svg',
              isRTL,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    BuildContext context,
    Gender gender,
    String text,
    String svgPath,
    bool isRTL,
  ) {
    return InkWell(
      onTap: () => onGenderChanged(gender),
      borderRadius: BorderRadius.circular(8.r), // Responsive radius
      child: Padding(
        padding:
            EdgeInsets.symmetric(vertical: 8.h), // Adjusted for better spacing
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (!isRTL) ...[
            //   _buildGenderText(text, svgPath, isRTL),
            //   Expanded(child: Container()),
            //   _buildRadioButton(gender),
            // ] else ...[
            //   _buildRadioButton(gender),
            //   Expanded(child: Container()),
            //   _buildGenderText(text, svgPath, isRTL),
            // ],
            _buildGenderText(text, svgPath, isRTL),
            Expanded(child: Container()),
            _buildRadioButton(gender),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderText(String text, String svgPath, bool isRTL) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (isRTL) ...[
          SvgPicture.asset(
            svgPath,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ] else ...[
          SvgPicture.asset(
            svgPath,
            width: 20.w,
            height: 20.h,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRadioButton(Gender gender) {
    return Container(
      width: 20.w, // Responsive width
      height: 20.h, // Responsive height
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selectedGender == gender
              ? AppColors.primary
              : Colors.grey.shade400,
          width: 1.5.w, // Responsive border width
        ),
        color: Colors.white,
      ),
      child: selectedGender == gender
          ? Center(
              child: Container(
                width: 12.w, // Responsive width
                height: 12.h, // Responsive height
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
    );
  }
}
