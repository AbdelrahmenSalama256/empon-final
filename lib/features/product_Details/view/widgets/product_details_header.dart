import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBackPressed;
  final VoidCallback onSharePressed;

  const ProductDetailHeader({
    Key? key,
    required this.title,
    required this.onBackPressed,
    required this.onSharePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24.w,
              color: Colors.black,
            ),
            onPressed: onBackPressed,
          ),

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Share button
          IconButton(
            icon: Icon(
              Icons.share_outlined,
              size: 24.w,
              color: Colors.black,
            ),
            onPressed: onSharePressed,
          ),
        ],
      ),
    );
  }
}
