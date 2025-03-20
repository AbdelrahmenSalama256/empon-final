import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Product image
        Container(
          height: 300.h,
          color: const Color(0xFF333333),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  'assets/images/shoes1.png',
                  fit: BoxFit.contain,
                  height: 250.h,
                ),
              ),
            ],
          ),
        ),

        // Image navigation dots
        Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Container(
                width: 8.w,
                height: 8.w,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == 0 ? Colors.black : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
