import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/product_Details/data/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductForm extends StatefulWidget {
  final bool? isUpdate;
  ProductModel? productData;
  final int? accountId;

  UpdateProductForm(
      {super.key, this.isUpdate, this.productData, this.accountId});

  @override
  State<UpdateProductForm> createState() => _UpdateProductFormState();
}

class _UpdateProductFormState extends State<UpdateProductForm> {
  final _formKey = GlobalKey<FormState>();
  final accountId =
      int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));



  @override
  Widget build(BuildContext context) {


    return BlocProvider(
      create: (context) => ProductCubit(sl<ProductRepo>())
        ..initControllers(true,
            name: widget.productData!.data!.name,
            description: widget.productData!.data!.description,
            price: widget.productData!.data!.price,
            category: widget.productData!.data!.category,
            variation: widget.productData!.data!.variations,
            details: widget.productData!.data!.details),
      child: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
      if (state is ProductSuccess) {
                showToast(context,
                    message: state.product.message!, state: ToastStates.success);
                Navigator.pop(context);
              }        },
        child: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
              final cubit = context.read<ProductCubit>();
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            }
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // Product Name Field
                        AppTextField(
                          controller: cubit.productNameController,
                          hintText: 'product_name_hint'.tr(context),
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(13.w),
                            child: SvgPicture.asset(
                              "assets/images/svg/product_name.svg",
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                    Column(
                      children: [
                        // Main Image Upload
                        _buildImageUploadField(
                          context,
                          label: 'main_product_image_placeholder'.tr(context),
                          images: cubit.productImage != null
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _buildImageThumbnail(cubit.productImage!, -1,
                                          isMain: true, deleteMain: cubit.removeMainImage),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          onPressed: cubit.pickMainImage,
                        ),
                        SizedBox(height: 20.h),
      
                        // Additional Images Upload
                        _buildImageUploadField(
                          context,
                          label: 'product_image_placeholder'.tr(context),
                          images: cubit.productImages.isNotEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Directionality(
                                          textDirection:
                                              context.read<GlobalCubit>().language ==
                                                      "ar"
                                                  ? TextDirection.ltr
                                                  : TextDirection.rtl,
                                          child: SizedBox(
                                            height: 40.h,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: cubit.productImages.length +
                                                  (cubit.productImages.length <
                                                          cubit.maxImages
                                                      ? 1
                                                      : 0),
                                              itemBuilder: (context, index) {
                                                if (index <
                                                    cubit.productImages.length) {
                                                  return _buildImageThumbnail(
                                                      cubit.productImages[index],
                                                      index ,deleteAdd: cubit.removeAdditionalImage(index));
                                                } else {
                                                  return Container(
                                                      margin: EdgeInsets.symmetric(
                                                          horizontal: 5.w),
                                                      child: _buildAddButton(cubit.pickAdditionalImages));
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          onPressed: cubit.pickAdditionalImages,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                    // Product details
                    Column(
                      children: [
                        AppTextField(
                          controller: cubit.productPriceController,
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
                        ),
                        SizedBox(height: 20.h),
      
                        Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Column(
                              children: [
                                ...List.generate(cubit.variations.length, (index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10.h),
      
                                      // === COLOR SELECTION ===
                                      _buildColorSelection(context, index,cubit.colorOptions,cubit.selectedColorIndex),
      
                                      SizedBox(height: 20.h),
      
                                      // === CUSTOM COLOR PICKER ===
                                      Align(
                                        alignment: AlignmentDirectional.centerStart,
                                        child: SizedBox(
                                          width: 180.w,
                                          child: AppButton(
                                            text: "custom_color_picker".tr(context),
                                            onPressed: () =>
                                                cubit.showCustomColorPicker(context,index ),
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
                                            child: AppDropdownField(
                                              contentPadding:  EdgeInsets.symmetric( vertical: 16.w),
                                              hint: 'size_hint'.tr(context),
                                              value: cubit
                                                  .findAttributeById(
                                                      cubit.variations[index]
                                                          ['attribute_value_id'])
                                                  ?.name,
                                              items: cubit.attributes
                                                  .map((s) => s.name)
                                                  .toList(),
                                              onChanged: (value) {
                                                final selected =
                                                    cubit.attributes.firstWhere(
                                                  (s) => s.name == value,
                                                );
      
                                                if (selected.id != -1) {
                                                  setState(() {
                                                    cubit.variations[index]
                                                            ['attribute_value_id'] =
                                                        selected.id;
                                                  });
                                                }
                                              },
                                              showErrorBorder: true,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 13.w),
                                                child: SvgPicture.asset(
                                                  "assets/images/svg/product_size.svg",
                                                  width: 20.w,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ),
                                          ),
      
                                          SizedBox(width: 10.w),
      
                                          // === QUANTITY FIELD ===
                                          Expanded(
                                            child: AppTextField(
                                              controller: cubit.variations[index]
                                                  ['stock'],
                                              hintText: 'quantity_hint'.tr(context),
                                              keyboardType: TextInputType.number,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 13.w),
                                                child: SvgPicture.asset(
                                                  "assets/images/svg/available_quantity.svg",
                                                  width: 20.w,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ),
                                          ),
      
                                          SizedBox(width: 10.w),
      
                                          // === PRICE FIELD ===
                                          Expanded(
                                            child: AppTextField(
                                              controller: cubit.variations[index]
                                                  ['price'],
                                              hintText: 'price_hint'.tr(context),
                                              keyboardType: TextInputType.number,
                                              prefixIcon: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 13.w),
                                                child: SvgPicture.asset(
                                                  "assets/images/svg/price.svg",
                                                  width: 20.w,
                                                  height: 20.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
      
                                      // === REMOVE BUTTON ===
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                          onPressed: () => setState(() {
                                            cubit.removeVariation(index);
                                          }),
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
                                  onPressed: () => setState(() {
                                    cubit.addVariation();
                                  }),
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: Text('add_variation'.tr(
                                      context)), //todo : 'add_variation'.tr(context)),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green),
                                ),
                              ],
                            )),
                        SizedBox(height: 20.h),
      
                        // Product Details Field
                        AppTextField(
                          controller: cubit.productDescriptionController,
                          hintText: 'product_details'.tr(context),
                          // maxLength: 5,
                          maxLines: 5,
      
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        // Size Dropdown
                        if (cubit.categories.isNotEmpty)
                          AppDropdownField(
                            hint: 'category'.tr(context),
                            value: cubit.selectedCategoryId != null
                                ? cubit.categories
                                    .firstWhere(
                                        (c) => c.id == cubit.selectedCategoryId)
                                    .name
                                : null,
                            isMultiSelect: false,
                            items: cubit.categories.map((c) => c.name).toList(),
                            selectedValues: cubit.selectedCategoryId != null
                                ? [
                                    cubit.categories
                                        .firstWhere(
                                            (c) => c.id == cubit.selectedCategoryId)
                                        .name
                                  ]
                                : [],
                            onChanged: (value) {
                              final selected =
                                  cubit.categories.firstWhere((c) => c.name == value);
                              cubit.selectCategory(selected.id);
                              setState(() {});
                            },
                            showErrorBorder: true,
                          ),
      
                        SizedBox(height: 20.h),
                        Text('additional_Product_Details'.tr(context),
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.h),
                        // Service Details Section
                        Column(
                          children: [
                            ...List.generate(cubit.serviceDetailsControllers.length,
                                (index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 12.h),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 8.h),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          controller:
                                              cubit.serviceDetailsControllers[index]
                                                  ['quality']!,
                                          hintText: 'price_hint'.tr(context),
                                          keyboardType: TextInputType.text,
                                          
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: AppTextField(
                                          controller:
                                              cubit.serviceDetailsControllers[index]
                                                  ['material']!,
                                          hintText: 'description_hint'.tr(context),
                                          keyboardType: TextInputType.text,
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
                                    onPressed: () => setState(() {
                                      cubit.addParoductDetail();
                                    }),
                                    icon: const Icon(Icons.add, color: Colors.white),
                                    label: Text('add_section'.tr(context)),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                if (cubit.serviceDetailsControllers.isNotEmpty)
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          cubit.removeParoductDetail();
                                        });
                                      },
                                      icon:
                                          const Icon(Icons.undo, color: Colors.white),
                                      label: Text('undo'.tr(context)),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
      
                        SizedBox(height: 20.h),
                      ],
                    ),
                    // Submit buttons
                    Column(
                      children: [
                        AppButton(
                          text: 'update_product_button'.tr(context),
                          onPressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              cubit.updateProduct(
                                  widget.productData!.data!.id!, accountId);
                              // Submit logic
                            }
                          },
                        ),
                        SizedBox(height: 8.h),
                        AppButton(
                          text: 'home'.tr(context),
                          type: AppButtonType.secondary,
                          onPressed: () {
                            context
                                .read<GlobalCubit>()
                                .setUserType(UserType.business);
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ],
                ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColorSelection(BuildContext context, int index,  List colors , int selected) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        final cubit = context.read<ProductCubit>();

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
                Text('select_color'.tr(context),
                    style: TextStyle(fontSize: 11.sp)),
                SizedBox(width: 5.w),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(colors.length, (i) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selected = i;
                              cubit.variations[index]['color_code'] =
                                  cubit.colorToHexString(colors[i]);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8.w),
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: colors[i],
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xff36C4ED),
                                width: selected == i ? 2 : 1,
                              ),
                            ),
                            child: cubit.variations[index]['color_code'] ==
                                    cubit.colorToHexString(colors[i])
                                ? Icon(Icons.check,
                                    size: 16.sp,
                                    color: colors[i].computeLuminance() >
                                            0.5
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
      },
    );
  }

  Widget _buildImageThumbnail(dynamic image, int index,
      {bool isMain = false, String? imageUrl,  VoidCallback? deleteMain, VoidCallback? deleteAdd}) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.r),
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: 40.w,
                      height: 40.h,
                    )
                  : image is XFile
                      ? Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                          width: 40.w,
                          height: 40.h,
                        )
                      : image is String
                          ? Image.network(
                              image,
                              fit: BoxFit.cover,
                              width: 40.w,
                              height: 40.h,
                            )
                          : const SizedBox(),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () =>
                  isMain ? deleteMain: deleteAdd,
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton( VoidCallback picAdd) {
    return GestureDetector(
      onTap: picAdd,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.grey.shade600,
            size: 20.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadField(
    BuildContext context, {
    required String label,
    Widget? images,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(15.r),
        strokeWidth: 1.w,
        dashPattern: const [9, 2],
        color: const Color(0xff8F95AB),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF0F2F9),
            borderRadius: BorderRadius.circular(15.r),
          ),
          height: 48.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: 8.w),
              Icon(Icons.cloud_upload_outlined,
                  color: const Color(0xff8F95AB), size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                label,
                style:
                    TextStyle(fontSize: 14.sp, color: const Color(0xff8F95AB)),
              ),
              SizedBox(width: 10.w),
              const Spacer(),
              images == null
                  ? const SizedBox()
                  : Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: images,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
