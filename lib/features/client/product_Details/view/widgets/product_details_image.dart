// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageSection extends StatefulWidget {
  const ProductImageSection({super.key});

  @override
  _ProductImageSectionState createState() => _ProductImageSectionState();
}

class _ProductImageSectionState extends State<ProductImageSection> {
  // Controller for the PageView
  final PageController _pageController = PageController();

  // List of image paths (replace with your actual image assets)
  final List<String> _images = [
    'assets/images/test-product.png',
    'assets/images/test-product2.png', // Example additional images
    'assets/images/test-product3.png',
    'assets/images/test-product4.png',
    'assets/images/test-product5.png',
  ];

  // Track the current page index
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Listen to page changes to update the current page index
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product image slider
        SizedBox(
          height: 250.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Center(
                child: Image.asset(
                  _images[index],
                  fit: BoxFit.contain,
                  height: 250.h,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 15.h,
        ),
        // Image navigation dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _images.length,
            (index) => Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    index == _currentPage ? Colors.black : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
