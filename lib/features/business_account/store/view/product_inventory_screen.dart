import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductInventoryScreen extends StatelessWidget {
  const ProductInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
      final cubit = context.read<SearchCubit>().productModel?.data;

      if (state is GoToProductLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (cubit == null || cubit.variations == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Column(
                    children: [
                       AppHeader(
                        title: 'available_product_numbers'.tr(context),
                        centerTitle: true,
                        showBackButton: true,
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: List.generate(
                                cubit.variations!.length,
                                (index) {
                                  final variation = cubit.variations![index];
                                  // Group variations by color
                                  final color = variation.color?.code;
                                  final sameColorVariations = cubit
                                      .variations!
                                      .where((v) => v.color?.code == color)
                                      .toList();
    
                                  final filteredSizes = <String>[];
                                  final filteredQuantities = <String>[];
    
                                  for (var v in sameColorVariations) {
                                    filteredSizes
                                        .add(v.attributeValue!.id.toString());
                                    filteredQuantities
                                        .add(v.stock.toString());
                                  }
    
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 16.h),
                                    child: _buildProductSection(
                                        context: context,
                                        sizes: filteredSizes,
                                        quantities: filteredQuantities,
                                        color: Color(int.parse(color!
                                            .replaceFirst('#', '0xff'))),
                                        name: cubit.name!,
                                        imageUrl: cubit.image!),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  Widget _buildProductSection(
      {required BuildContext context,
      required List<String> sizes,
      required List<String> quantities,
      required Color color,
      required String imageUrl,
      required String name}) {
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
                          'color'.tr(context),
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
                              color: color),
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
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Product name
                    Text(
                      name,
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
