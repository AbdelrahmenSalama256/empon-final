import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const RelatedProductsSection({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              'منتجات مشابهة',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.end,
            ),
          ),

          SizedBox(height: 12.h),

          // Related products list
          SizedBox(
            height: 180.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true, // For RTL layout
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return RelatedProductItem(
                  image: product['image'],
                  name: product['name'],
                  price: product['price'],
                  currency: product['currency'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RelatedProductItem extends StatelessWidget {
  final String image;
  final String name;
  final double price;
  final String currency;

  const RelatedProductItem({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140.w,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Product image
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(8),
                topRight: const Radius.circular(8),
              ),
            ),
            child: Center(
              child: Image.asset(
                image,
                height: 80.h,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Product info
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.end,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 4.h),

                // Price
                Text(
                  '$price $currency',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
