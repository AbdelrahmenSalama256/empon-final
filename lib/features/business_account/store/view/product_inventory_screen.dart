import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductInventoryScreen extends StatelessWidget {
  const ProductInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'الاعداد المتاحة من المنتج',
              centerTitle: true,
              showBackButton: true,
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      _buildProductSection(
                        sizes: const ['42', '41', '39', '38'],
                        quantities: const ['15', '8', '7', '10'],
                        isBlueCheck: true,
                      ),
                      SizedBox(height: 16.h),
                      _buildProductSection(
                        sizes: const ['24', '41', '39', '38'],
                        quantities: const ['15', '9', '15', '2'],
                        isBlueCheck: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductSection({
    required List<String> sizes,
    required List<String> quantities,
    required bool isBlueCheck,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right side - Product image and color
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color indicator
                    Row(
                      children: [
                        Text(
                          'اللون',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary),
                            color:
                                isBlueCheck ? AppColors.primary : Colors.orange,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Container(
                        width: 160.w,
                        height: 120.h,
                        color: const Color(0xFF2A2A2A),
                        child: Image.asset(
                          'assets/images/test-product.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Product name
                    Text(
                      'حذاء رياضي أو أديداس 270',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),

                // Left side - Table
                Expanded(
                  child: Column(
                    children: [
                      // Header row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'المقاس',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'العدد',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),

                      // Data rows
                      for (int i = 0; i < sizes.length; i++)
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  sizes[i],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  quantities[i],
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
