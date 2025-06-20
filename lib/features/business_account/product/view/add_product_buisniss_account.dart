import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/widgets/add_service_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/add_product_form.dart';

class AddProductPage extends StatefulWidget {
  final int businessAccountId;
  const AddProductPage({super.key, required this.businessAccountId});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => ProductCubit(sl<ProductRepo>()),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              AppHeader(
                title: 'add_product_title'.tr(context),
                centerTitle: true,
                showBackButton: true,
                onBackPressed: () => Navigator.pop(context),
              ),

              // Form Content
              TabBar(
                controller: _tabController,
                labelColor: AppColors.white,
                unselectedLabelColor: const Color(0xff152354),
                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                tabs: [
                  Tab(
                    child: Text(
                      "product_add_subtitle".tr(context),
                      style: TextStyle(
                        fontFamily:
                            context.read<GlobalCubit>().language == "ar"
                                ? 'Beiruti'
                                : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "service_add_subtitle".tr(context),
                      style: TextStyle(
                        fontFamily:
                            context.read<GlobalCubit>().language == "ar"
                                ? 'Beiruti'
                                : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children:[
                    SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'product_add_button'.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Divider(height: 1.h),

                        // Main form content
                        const AddProductForm(),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'product_add_button'.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Divider(height: 1.h),

                        // Main form content
                        const AddServiceForm(),
                      ],
                    ),
                  ),
                  ] ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
