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
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        child: Column(
          children: Gender.values.map((gender) {
            final isSelected = selectedGender == gender;
            return Column(
              children: [
                _buildGenderOption(
                  context,
                  gender,
                  gender.toString().split('.').last.tr(context),
                  'assets/images/svg/${gender.toString().split('.').last}.svg',
                  isRTL,
                  isSelected,
                ),
                if (gender != Gender.values.last) SizedBox(height: 12.h),
              ],
            );
          }).toList(),
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
    bool isSelected,
  ) {
    return InkWell(
      onTap: () => onGenderChanged(gender),
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGenderText(text, svgPath, isRTL),
            const Spacer(),
            _buildRadioButton(isSelected),
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

  Widget _buildRadioButton(bool isSelected) {
    return Container(
      width: 20.w,
      height: 20.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.grey.shade400,
          width: 1.5.w,
        ),
        color: Colors.white,
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 12.w,
                height: 12.h,
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
