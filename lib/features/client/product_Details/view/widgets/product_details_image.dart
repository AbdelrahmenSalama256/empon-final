import 'package:carousel_slider/carousel_slider.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'gallery_slider.dart';

class ProductImageSection extends StatefulWidget {
  final List<String> images;
  final bool autoPlay;
  final Duration autoPlayInterval;

  const ProductImageSection({
    super.key,
    required this.images,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
  });

  @override
  State<ProductImageSection> createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return SizedBox(
        height: 250.h,
        child: const Center(child: Text('No images available')),
      );
    }

    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            height: 250.h,
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 250.h,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: widget.autoPlay,
                    autoPlayInterval: widget.autoPlayInterval,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                  ),
                  items: widget.images.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final String imageUrl = entry.value;
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            // Show full-screen GallerySlider dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  backgroundColor: Colors.transparent,
                                  child: GallerySlider(
                                    index: index,
                                    photos: widget.images,
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              height: 250.h,
                              errorBuilder: (context, error, stackTrace) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Image.asset(
                                    "assets/images/placholder.jpg",
                                    fit: BoxFit.cover,
                                    height: 250.h,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                // Navigation Arrows
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: _currentPage > 0
                        ? () => _carouselController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            )
                        : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: _currentPage > 0
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      size: 24.w,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: _currentPage < widget.images.length - 1
                        ? () => _carouselController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            )
                        : null,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: _currentPage < widget.images.length - 1
                          ? AppColors.primary
                          : Colors.grey.shade400,
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 15.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.images.length,
            (index) => GestureDetector(
              onTap: () {
                _carouselController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 10.w,
                height: 10.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  border: Border.all(
                    color: index == _currentPage
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    width: 1.w,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
