import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/search/data/model/search_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchResultsSection extends StatelessWidget {
  final Function(int) onGoingTap;
  final List<SearchProduct> products;

  const SearchResultsSection(
      {super.key, required this.products, required this.onGoingTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'search_results'.tr(context),
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => onGoingTap(product.id),
              child: ListTile(
                leading: Image.network(
                  product.image,
                  width: 50.w,
                  height: 50.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.search_off,
                        color: Colors.black,
                        size: 30.sp,
                      ),
                    );
                  },
                ),
                title: Text(product.name),
                subtitle: Text('${product.price} ${product.description}'),
                onTap: () {
                  // Navigate to product details
                  if (kDebugMode) {
                    print('Tapped on product: ${product.name}');
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
