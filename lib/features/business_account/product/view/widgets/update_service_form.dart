import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_state.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UpdateServiceForm extends StatefulWidget {
  
  ServiceModel? serviceData;
   UpdateServiceForm({super.key, this.serviceData});

  @override
  State<UpdateServiceForm> createState() => _UpdateServiceFormState();
}

class _UpdateServiceFormState extends State<UpdateServiceForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ServiceCubit(sl<ServiceRepo>())..initControllers(
            true,
            name: widget.serviceData!.data!.name,
            details: widget.serviceData!.data!.details,
            price: widget.serviceData!.data!.price,
            category: widget.serviceData!.data!.categoties[0].name,
            categoriesData: widget.serviceData!.data!.categoties,
            features: widget.serviceData!.data!.features
          ),
      child: BlocListener<ServiceCubit, ServiceState>(
        listener: (context, state) {
          if (state is ServiceSuccess) {
            showToast(context, message: state.model.message!, state: ToastStates.success);
            Navigator.pop(context);
          }
        },
        child: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            final cubit = context.read<ServiceCubit>();
            if (state is ServiceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Basic Service information
                Column(
                  children: [
                    // Service Name Field
                    AppTextField(
                      controller: cubit.nameController,
                      hintText: 'service_name'.tr(context),
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

                // Image upload sections
                Column(
                  children: [
                    // Main Image Upload
                    _buildImageUploadField(
                      context,
                      label: 'main_service_image'.tr(context),
                      images: cubit.mainImage != null
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _buildImageThumbnail(cubit.mainImage!, -1,
                                      isMain: true),
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
                      label: 'service_image_placeholder'.tr(context),
                      images: cubit.sliderImages.isNotEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Directionality(
                                      textDirection: context
                                                  .read<GlobalCubit>()
                                                  .language ==
                                              "ar"
                                          ? TextDirection.ltr
                                          : TextDirection.rtl,
                                      child: SizedBox(
                                        height: 40.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cubit.sliderImages.length +
                                              (cubit.sliderImages.length <
                                                      cubit.maxImages
                                                  ? 1
                                                  : 0),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                cubit.sliderImages.length) {
                                              return _buildImageThumbnail(
                                                  cubit.sliderImages[index],
                                                  index);
                                            } else {
                                              return Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 5.w),
                                                  child: _buildAddButton(cubit
                                                      .pickAdditionalImages));
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

                // Service details
                Column(
                  children: [
                    /// Price Field
                    AppTextField(
                      controller: cubit.priceController,
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

                    /// Product Details
                    AppTextField(
                      controller: cubit.detailsController,
                      hintText: 'service_details'.tr(context),
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 20.h),

                    /// Category Dropdown
                    if (cubit.categories.isNotEmpty)
                      AppDropdownField(
                        hint: 'category'.tr(context),
                        value: cubit.categoryServiceId != null
                            ? cubit.categories
                                .firstWhere(
                                    (c) => c.id == cubit.categoryServiceId)
                                .name
                            : null,
                        isMultiSelect: false,
                        items: cubit.categories.map((c) => c.name).toList(),
                        selectedValues: cubit.categories
                            .where(
                                (c) => cubit.selectedCategoryIds.contains(c.id))
                            .map((c) => c.name)
                            .toList(),
                        onChanged: (value) {
                          final selected = cubit.categories
                              .firstWhere((c) => c.name == value);
                          cubit.categoryServiceId = selected.id;
                          setState(() {});
                        },
                        showErrorBorder: true,
                      ),

                    SizedBox(height: 20.h),
                    Text("additional_service_Details".tr(context),
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight:
                                FontWeight.bold)), //todo: make localized
                    SizedBox(height: 10.h),
                    Column(
                      children: [
                        ...List.generate(cubit.featureControllers.length,
                            (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: AppTextField(
                              controller: cubit.featureControllers[index],
                              hintText:
                                  '${'feature_hint'.tr(context)} ${index + 1}',
                              keyboardType: TextInputType.text,
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: cubit.addFeature,
                                icon: const Icon(Icons.add),
                                label: Text('add_section'.tr(context)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            if (cubit.featureControllers.isNotEmpty)
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    cubit.featureControllers.last.dispose();
                                    cubit.featureControllers.removeLast();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.undo),
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
                      text: 'service_Update_subtitle'.tr(context),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          cubit.accountId =
                              context.read<GlobalCubit>().businessId;
                          cubit.updateService(widget.serviceData!.data!.id!);
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
    ));
  }

  Widget _buildImageThumbnail(dynamic image, int index,
      {bool isMain = false,
      VoidCallback? deleteMain,
      VoidCallback? deleteAdd}) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          SizedBox(
            width: 40.w,
            height: 40.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13.r),
              child: Image.file(
                File(image.path),
                fit: BoxFit.cover,
                width: 40.w,
                height: 40.h,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => isMain ? deleteMain : deleteAdd,
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

  Widget _buildAddButton(VoidCallback picAdd) {
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
