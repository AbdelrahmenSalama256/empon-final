import 'dart:io';

import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({super.key, required this.cubit});
  final bool cubit;
  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  XFile? _mainImage;
  final List<XFile> _additionalImages = [];
  final ImagePicker _picker = ImagePicker();
  final int _maxImages = 10;
  

  Future<void> _pickMainImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _mainImage = XFile(image.path);
      });
    }
  }

  Future<void> _pickAdditionalImages() async {
    final availableSlots = _maxImages - _additionalImages.length;
    if (availableSlots <= 0) return;

    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _additionalImages.addAll(images.take(availableSlots));
      });
    }
  }

  void _removeMainImage() {
    setState(() {
      _mainImage = null;
    });
  }

  void _removeAdditionalImage(int index) {
    setState(() {
      _additionalImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_mainImage != null) {
      if (widget.cubit) {
        setState(() {
          context.read<ProductCubit>().productImage = _mainImage;
        });
      } else {
        context.read<ServiceCubit>().mainImage = _mainImage;
      }
    }
    if (_additionalImages.isNotEmpty) {
      if (widget.cubit) {
        setState(() {
          context.read<ProductCubit>().productImages = _additionalImages;
        });
      } else {
        context.read<ServiceCubit>().sliderImages = _additionalImages;
      }
    }
    return Column(
      children: [
        // Main Image Upload
        _buildImageUploadField(
          context,
          label: widget.cubit == true
              ? 'main_product_image_placeholder'.tr(context)
              : 'main_service_image'.tr(context),
          images: _mainImage != null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildImageThumbnail(_mainImage!, -1, isMain: true),
                    ],
                  ),
                )
              : const SizedBox(),
          onPressed: _pickMainImage,
        ),
        SizedBox(height: 20.h),

        // Additional Images Upload
        _buildImageUploadField(
          context,
          label: widget.cubit == true
              ? 'product_image_placeholder'.tr(context)
              : 'service_image_placeholder'.tr(context),
          images: _additionalImages.isNotEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Directionality(
                          textDirection:
                              context.read<GlobalCubit>().language == "ar"
                                  ? TextDirection.ltr
                                  : TextDirection.rtl,
                          child: SizedBox(
                            height: 40.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _additionalImages.length +
                                  (_additionalImages.length < _maxImages
                                      ? 1
                                      : 0),
                              itemBuilder: (context, index) {
                                if (index < _additionalImages.length) {
                                  return _buildImageThumbnail(
                                      _additionalImages[index], index);
                                } else {
                                  return Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      child: _buildAddButton());
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
          onPressed: _pickAdditionalImages,
        ),
        SizedBox(height: 20.h),
      ],
    );
  }

  Widget _buildImageThumbnail(dynamic image, int index, {bool isMain = false,String? imageUrl}) {
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
                  isMain ? _removeMainImage() : _removeAdditionalImage(index),
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

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _pickAdditionalImages,
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
