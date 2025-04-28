import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductPromotionSection extends StatefulWidget {
  const ProductPromotionSection({super.key});

  @override
  State<ProductPromotionSection> createState() =>
      _ProductPromotionSectionState();
}

class _ProductPromotionSectionState extends State<ProductPromotionSection> {
  String? _selectedExpectedAppearance;
  String? _selectedAdBudget;
  String? _selectedProvince;
  String? _selectedCity;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),

        // Promotion Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'enable_promotion_label'.tr(context),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            CupertinoSwitch(
              value: false,
              onChanged: (value) {},
              activeTrackColor: AppColors.primary,
            )
          ],
        ),
        SizedBox(height: 20.h),

        // Ad Duration Dropdown
        AppDropdownField(
          hint: 'ad_duration_hint'.tr(context),
          value: null,
          items: 'ad_duration_items'.tr(context).split(','),
          onChanged: (value) {},
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: Icon(
              CupertinoIcons.clock,
              size: 20.sp,
              color: const Color(0xff8F95AB),
            ),
          ),
          validator: (value) => Validators.validateRequired(
              value, 'ad_duration_hint'.tr(context), context),
        ),
        SizedBox(height: 20.w),

        // Gender Dropdown
        AppDropdownField(
          hint: 'gender_hint'.tr(context),
          value: null,
          items: 'gender_items'.tr(context).split(','),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SvgPicture.asset(
              "assets/images/svg/gender.svg",
              width: 20.w,
              height: 20.h,
              // color: const Color(0xff8F95AB),
            ),
          ),
          onChanged: (value) {},
          validator: (value) => Validators.validateRequired(
              value, 'gender_hint'.tr(context), context),
        ),
        SizedBox(height: 20.h),
        // Expected Appearance and Ad Budget Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: AppDropdownField(
                hint: 'ad_budget_hint'.tr(context),
                value: _selectedAdBudget,
                items: 'ad_budget_items'.tr(context).split(','),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SvgPicture.asset(
                    "assets/images/svg/budget.svg", // You should add this SVG
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                onChanged: (value) => setState(() => _selectedAdBudget = value),
                validator: (value) => Validators.validateRequired(
                    value, 'ad_budget_hint'.tr(context), context),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: AppDropdownField(
                hint: 'expected_appearance_hint'.tr(context),
                value: _selectedExpectedAppearance,
                items: 'expected_appearance_items'.tr(context).split(','),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SvgPicture.asset(
                    "assets/images/svg/appearance.svg",
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                onChanged: (value) =>
                    setState(() => _selectedExpectedAppearance = value),
                validator: (value) => Validators.validateRequired(
                    value, 'expected_appearance_hint'.tr(context), context),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Province Dropdown
            Expanded(
              child: AppDropdownField(
                hint: 'province_hint'.tr(context),
                value: _selectedProvince,
                items: 'province_items'.tr(context).split(','),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SvgPicture.asset(
                    "assets/images/svg/location.svg",
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                onChanged: (value) => setState(() => _selectedProvince = value),
                validator: (value) => Validators.validateRequired(
                    value, 'province_hint'.tr(context), context),
              ),
            ),
            SizedBox(width: 10.w),
            // City Dropdown
            Expanded(
              child: AppDropdownField(
                hint: 'city_hint'.tr(context),
                value: _selectedCity,
                items: 'city_items'.tr(context).split(','),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: SvgPicture.asset(
                    "assets/images/svg/location.svg",
                    width: 20.w,
                    height: 20.h,
                  ),
                ),
                onChanged: (value) => setState(() => _selectedCity = value),
                validator: (value) => Validators.validateRequired(
                    value, 'city_hint'.tr(context), context),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Location Note Label
        Text(
          '* ${'location_auto_select_note'.tr(context)}',
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}
