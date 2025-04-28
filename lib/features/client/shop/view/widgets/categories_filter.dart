import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesFilter extends StatefulWidget {
  final Function(String) onCategorySelected;

  const CategoriesFilter({super.key, required this.onCategorySelected});

  @override
  State<CategoriesFilter> createState() => _CategoriesFilterState();
}

class _CategoriesFilterState extends State<CategoriesFilter> {
  String selectedCategory = 'shoes';

  final List<Map<String, dynamic>> categories = [
    {
      'id': 'entertainment',
      'name': 'ترفيه',
      'svgPath': 'assets/images/brand-two.png',
    },
    {
      'id': 'perfumes',
      'name': 'عطور',
      'svgPath': 'assets/images/brand-two.png',
    },
    {'id': 'offers', 'name': 'عروض', 'svgPath': 'assets/images/brand-two.png'},
    {
      'id': 'clothes',
      'name': 'ملابس',
      'svgPath': 'assets/images/brand-two.png',
    },
    {'id': 'shoes', 'name': 'احذية', 'svgPath': 'assets/images/brand-two.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true, // For RTL layout
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category['id'];
                widget.onCategorySelected(selectedCategory);
              });
            },
            child: Container(
              width: 80.w,
              margin: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56.w,
                    height: 56.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border:
                          isSelected
                              ? Border.all(
                                color: const Color(0xff64B95C),
                                width: 2.w,
                              )
                              : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Image.asset(
                        category['svgPath'],
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    category['name'],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff202727),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
