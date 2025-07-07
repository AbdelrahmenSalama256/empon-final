import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/widgets/most_visited.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/navigation.dart';
import '../../../../business_account/home/view/home_buisniss.dart';
import '../../../home/view/widgets/section_header_home.dart';
import '../cubit/business_cubit.dart';
import '../cubit/business_state.dart';

class MenuMostVisited extends StatelessWidget {
  final bool? isVendor;
  final BusinessCubit businessCubit;

  const MenuMostVisited({
    super.key,
    required this.isVendor,
    required this.businessCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          backgroundColor: Colors.white,
          title: "most_visited".tr(context),
          padding: const EdgeInsets.all(0),
          showCloseButton: false,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<BusinessCubit, BusinessState>(
          builder: (context, state) {
            return state is BusinessLoading
                ? const Center(child: LinearProgressIndicator())
                : businessCubit.businesses.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: 16.h),
                        child: Text(
                          "no_brands_found".tr(context),
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 90.h,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: businessCubit.businesses.map((business) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: VisitedItem(
                                name: business.name,
                                imageUrl: business.imageUrl,
                                onTap: () {
                                  navigateTo(
                                    context,
                                    HomeStoreScreen(
                                      businessAccountId: business.id,
                                      isVendor: false,
                                      businessAccountname: business.name,
                                    ),
                                  );
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      );
          },
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
