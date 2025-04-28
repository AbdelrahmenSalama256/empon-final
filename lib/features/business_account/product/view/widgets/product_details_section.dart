import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/business_account/product/view/widgets/color_picker_dialog.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter_svg/svg.dart';

class ProductDetailsSection extends StatefulWidget {
  const ProductDetailsSection({super.key});

  @override
  State<ProductDetailsSection> createState() => _ProductDetailsSectionState();
}

class _ProductDetailsSectionState extends State<ProductDetailsSection> {
  int _selectedColorIndex = 0;
  Color _customColor = Colors.blue;

  // Color options
  final List<Color> _colorOptions = [
    const Color(0xFF0D47A1),
    Colors.black,
    const Color(0xFFFFC107),
    const Color(0xFFE53935),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFF9C27B0),
    Colors.white,
  ];
  void _showCustomColorPicker() {
    showColorPickerDialog(
      context,
      initialColor: _customColor,
      onColorChanged: (Color color) {
        setState(() => _customColor = color);
      },
      onSavePressed: () {
        setState(() {
          _colorOptions.add(_customColor);
          _selectedColorIndex = _colorOptions.length - 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Color Selection
        _buildColorSelection(context),
        SizedBox(height: 20.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(
            width: 180.w,
            child: AppButton(
              text: "custom_color_picker".tr(context),
              onPressed: _showCustomColorPicker,
              backgroundColor: Colors.green,
              prefixIcon:
                  Icon(CupertinoIcons.plus, size: 20.sp, color: Colors.white),
              textStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        // Size Dropdown
        AppDropdownField(
          hint: 'size_hint'.tr(context),
          value: null,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SvgPicture.asset(
              "assets/images/svg/product_size.svg",
              width: 20.w,
              height: 20.h,
            ),
          ),
          items: 'size_items'.tr(context).split(','),
          onChanged: (value) {},
          validator: (value) => Validators.validateRequired(
              value, 'size_items'.tr(context), context),
        ),
        SizedBox(height: 20.h),

        // Qunatity Field
        AppTextField(
          controller: TextEditingController(),
          hintText: 'quantity_hint'.tr(context),
          keyboardType: TextInputType.number,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SvgPicture.asset(
              "assets/images/svg/available_quantity.svg",
              width: 20.w,
              height: 20.h,
            ),
          ),
          validator: (value) => Validators.validateRequired(
              value, 'quantity_hint'.tr(context), context),
        ),
        SizedBox(height: 20.h),

        // Price Field
        AppTextField(
          controller: TextEditingController(),
          hintText: 'price_hint'.tr(context),
          keyboardType: TextInputType.number,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SvgPicture.asset(
              "assets/images/svg/price.svg",
              width: 20.w,
              height: 20.h,
            ),
          ),
          validator: (value) => Validators.validateRequired(
              value, 'price_hint'.tr(context), context),
        ),
        SizedBox(height: 20.h),

        // Product Details Field
        AppTextField(
          controller: TextEditingController(),
          hintText: 'product_details'.tr(context),
          // maxLength: 5,
          maxLines: 5,

          keyboardType: TextInputType.number,
          // prefixIcon: SizedBox(
          //   width: 20.w,
          //   height: 20.h,
          //   child: Align(
          //     alignment: AlignmentDirectional.topStart,
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 13.w),
          //       child: SvgPicture.asset(
          //         "assets/images/svg/price.svg",
          //       ),
          //     ),
          //   ),
          // ),
          validator: (value) => Validators.validateRequired(
              value, 'product_details'.tr(context), context),
        ),
        SizedBox(height: 20.h),
        // Size Dropdown
        AppDropdownField(
          hint: 'main_category'.tr(context),
          value: null,
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13.w),
            child: SvgPicture.asset(
              "assets/images/svg/main_category.svg",
              width: 20.w,
              height: 20.h,
            ),
          ),
          items: 'main_category'.tr(context).split(','),
          onChanged: (value) {},
          validator: (value) => Validators.validateRequired(
              value, 'main_category'.tr(context), context),
        ),
        // SizedBox(height: 20.h),
        // AppDropdownField(
        //   hint: 'main_category'.tr(context),
        //   value: null,
        //   prefixIcon: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 13.w),
        //     child: SvgPicture.asset(
        //       "assets/images/svg/product_size.svg",
        //       width: 20.w,
        //       height: 20.h,
        //     ),
        //   ),
        //   items: 'main_category'.tr(context).split(','),
        //   onChanged: (value) {},
        //   validator: (value) => Validators.validateRequired(
        //       value, 'main_category'.tr(context), context),
        // ),
      ],
    );
  }

  Widget _buildColorSelection(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(height: 0.h),
      // Color Selection
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'select_product_color'.tr(context),
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'select_color'.tr(context),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF8F95AB),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        _colorOptions.length,
                        (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColorIndex = index;
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: _colorOptions[index],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xff36C4ED),
                                width: _selectedColorIndex == index ? 2 : 1,
                              ),
                              boxShadow: _colorOptions[index] == Colors.white
                                  ? [
                                      BoxShadow(
                                        // ignore: deprecated_member_use
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                      )
                                    ]
                                  : null,
                            ),
                            child: _selectedColorIndex == index
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color: _colorOptions[index]
                                                .computeLuminance() >
                                            0.5
                                        ? Colors.black
                                        : Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    ]);
  }
}
