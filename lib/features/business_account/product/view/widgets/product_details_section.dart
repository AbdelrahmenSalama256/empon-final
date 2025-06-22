import 'package:embone/core/component/widgets/app_button.dart';
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
  List<Map<String, TextEditingController>> serviceDetailsControllers = [];

  void addParoductDetail() {
    serviceDetailsControllers.add({
      'price': TextEditingController(),
      'description': TextEditingController(),
    });
    setState(() {});
  }

  List<Map<String, dynamic>> variations = [];

  void addVariation() {
    variations.add({
      "color": null, // will be a Color object
      "size": null,
      "priceController": TextEditingController(),
      "quantityController": TextEditingController(),
    });
    setState(() {});
  }

  void removeVariation(int index) {
    variations[index]['priceController']?.dispose();
    variations[index]['quantityController']?.dispose();
    variations.removeAt(index);
    setState(() {});
  }

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
  void _showCustomColorPicker(int index) {
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
          variations[index]['color'] = _customColor;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        Align(
            alignment: AlignmentDirectional.centerStart,
            child: Column(
              children: [
                ...List.generate(variations.length, (index) {
                  final variation = variations[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),

                      // === COLOR SELECTION ===
                      _buildColorSelection(context, index),

                      SizedBox(height: 20.h),

                      // === CUSTOM COLOR PICKER ===
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: SizedBox(
                          width: 180.w,
                          child: AppButton(
                            text: "custom_color_picker".tr(context),
                            onPressed: () => _showCustomColorPicker(index),
                            backgroundColor: Colors.green,
                            prefixIcon: Icon(CupertinoIcons.plus,
                                size: 20.sp, color: Colors.white),
                            textStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // === SIZE DROPDOWN ===
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: variation['sizeController'] ??=
                                  TextEditingController(text: variation['size']),
                              hintText: 'size_hint'.tr(context),
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 13.w),
                                child: SvgPicture.asset(
                                  "assets/images/svg/product_size.svg",
                                  width: 20.w,
                                  height: 20.h,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              onChanged: (value) {
                                variation['size'] = value;
                              },
                              validator: (value) => Validators.validateRequired(
                                value,
                                'size_hint'.tr(context),
                                context,
                              ),
                            ),
                          ),
                          
                          SizedBox(width: 10.w),
                          
                          // === QUANTITY FIELD ===
                          Expanded(
                            child: AppTextField(
                              controller: variation['quantityController'],
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
                          ),
                          
                          SizedBox(width: 10.w),
                          
                          // === PRICE FIELD ===
                          Expanded(
                            child: AppTextField(
                              controller: variation['priceController'],
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
                          ),
                        ],
                      ),

                      // === REMOVE BUTTON ===
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () => removeVariation(index),
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.red),
                        ),
                      ),

                      const Divider(thickness: 1.2),
                    ],
                  );
                }),

                // === ADD VARIATION BUTTON ===
                ElevatedButton.icon(
                  onPressed: addVariation,
                  icon: const Icon(Icons.add),
                  label: const Text(
                      "Add Variation"), //todo : 'add_variation'.tr(context)),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )),
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
        SizedBox(height: 20.h),
        Text('additional_Product_Details'.tr(context),
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        // Service Details Section
        Column(
          children: [
            ...List.generate(serviceDetailsControllers.length, (index) {
              final item = serviceDetailsControllers[index];
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: item['price']!,
                          hintText: 'price_hint'.tr(context),
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.validateRequired(
                              value, 'price_hint'.tr(context), context),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: AppTextField(
                          controller: item['description']!,
                          hintText: 'description_hint'.tr(context),
                          keyboardType: TextInputType.text,
                          validator: (value) => Validators.validateRequired(
                              value, 'description_hint'.tr(context), context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            // "+" Button
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: addParoductDetail,
                    icon: const Icon(Icons.add),
                    label: Text('add_section'.tr(context)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                ),
                SizedBox(width: 10.w),
                if (serviceDetailsControllers.isNotEmpty)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        serviceDetailsControllers.last['price']!.dispose();
                        serviceDetailsControllers.last['description']!
                            .dispose();
                        serviceDetailsControllers.removeLast();
                        setState(() {});
                      },
                      icon: const Icon(Icons.undo),
                      label: Text('undo'.tr(context)),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ),
              ],
            ),
          ],
        ),

        SizedBox(height: 20.h),

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

  Widget _buildColorSelection(BuildContext context, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'select_product_color'.tr(context),
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Text('select_color'.tr(context), style: TextStyle(fontSize: 11.sp)),
            SizedBox(width: 5.w),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_colorOptions.length, (i) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = i;
                          variations[index]['color'] = _colorOptions[i];
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 8.w),
                        width: 24.w,
                        height: 24.w,
                        decoration: BoxDecoration(
                          color: _colorOptions[i],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff36C4ED),
                            width: _selectedColorIndex == i ? 2 : 1,
                          ),
                        ),
                        child: _selectedColorIndex == i
                            ? Icon(Icons.check,
                                size: 16.sp,
                                color: _colorOptions[i].computeLuminance() > 0.5
                                    ? Colors.black
                                    : Colors.white)
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
