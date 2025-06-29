import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductDetails({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item['nameKey'] ?? '',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 4.h),
          Text(
            '${'currency'.tr(context)}${(item['price'] as double?)?.toStringAsFixed(2) ?? '0.00'}',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: ClipRRect(
                      child: Image.network(
                        item['brandLogo'] ?? '',
                        width: 24.w,
                        height: 24.h,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                            ),
                            child:
                                const Icon(CupertinoIcons.photo_camera_solid),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    item['brandKey'] ?? '',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xff080808),
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
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
