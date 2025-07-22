import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';

class GallerySlider extends StatefulWidget {
  const GallerySlider({
    super.key,
    required this.index,
    required this.photos,
  });

  final int index;
  final List<String> photos;

  @override
  State<GallerySlider> createState() => _GallerySliderState();
}

class _GallerySliderState extends State<GallerySlider> {
  late final PageController controller;
  int currentIndex = 0;

  static const int kLoopFactor = 1000;

  int get initialPage => widget.photos.length * kLoopFactor + widget.index;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: initialPage);
    currentIndex = widget.index;
  }

  int _getRealIndex(int page) {
    return page % widget.photos.length;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //! Close Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: CircleAvatar(
                radius: 14.h,
                backgroundColor: AppColors.white,
                child: const Icon(
                  Icons.close,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 36.h),

        //! PageView
        Expanded(
          child: Stack(
            children: [
              PageView.builder(
                controller: controller,
                onPageChanged: (value) {
                  final realIndex = _getRealIndex(value);
                  setState(() {
                    currentIndex = realIndex;
                  });
                },
                itemBuilder: (context, index) {
                  final realIndex = _getRealIndex(index);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.w),
                    child: Image.network(
                      widget.photos[realIndex],
                      fit: BoxFit.contain,
                    ),
                  );
                },
              ),
              //! Control Buttons
              Positioned(
                left: 16.w,
                right: 16.w,
                top: 0,
                bottom: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //! Backward Button
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.white.withOpacity(.5),
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),

                    //! Forward Button
                    Padding(
                      padding: EdgeInsetsDirectional.only(start: 16.w),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: AppColors.white.withOpacity(.5),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        //! Dots Indicator
        Wrap(
          spacing: 4.w,
          children: List.generate(
            widget.photos.length,
            (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentIndex == index ? 24.w : 8.h,
                height: 8.h,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.primary
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 48.h),
      ],
    );
  }
}
