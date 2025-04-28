import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/order/view/widgets/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'my_orders'.tr(context),
              centerTitle: true,
              showBackButton: true,
            ),
            // Tab Bar
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: TabBar(
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
                      "delivered".tr(context),
                      style: TextStyle(
                        fontFamily: context.read<GlobalCubit>().language == "ar"
                            ? 'Beiruti'
                            : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "canceled".tr(context),
                      style: TextStyle(
                        fontFamily: context.read<GlobalCubit>().language == "ar"
                            ? 'Beiruti'
                            : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "in_delivery".tr(context),
                      style: TextStyle(
                        fontFamily: context.read<GlobalCubit>().language == "ar"
                            ? 'Beiruti'
                            : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Delivered Orders Tab
                  OrdersList(
                    status: "delivered".tr(context),
                    statusColor: const Color(0xff64B95C),
                    showCancelButton: false,
                  ),

                  // Canceled Orders Tab
                  OrdersList(
                    status: "canceled".tr(context),
                    statusColor: const Color(0xffEC4B4B),
                    showCancelButton: false,
                  ),

                  // In Delivery Orders Tab
                  OrdersList(
                    status: "in_delivery".tr(context),
                    statusColor: AppColors.primary,
                    showCancelButton: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
