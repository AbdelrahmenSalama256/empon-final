import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/dashboard/view/cubit/statistics_cubit.dart';
import 'package:embone/features/business_account/dashboard/view/widgets/dashboard_chart.dart';
import 'package:embone/features/business_account/dashboard/view/widgets/dashboard_overview.dart';
import 'package:embone/features/client/wallet/view/wallet_details_screen.dart';
import 'package:embone/features/client/wallet/view/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
     final cubit = context.read<StatisticsCubit>();
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () =>
              context.read<StatisticsCubit>()
              .fetchStatistics(
                context.read<GlobalCubit>().businessId
              ),
              
            child: SafeArea(
              child: Column(
                children: [
                  // SizedBox(height: 16.h),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.h),
                              border:
                                  Border.all(color: AppColors.grey, width: 0.2.w),
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 20.h,
                              color: AppColors.black,
                            ),
                          ),
                          onPressed: () {
                            context.read<GlobalCubit>().changeBottomNavIndex(0);
                          },
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200.r),
                                child: Image.asset(
                                  'assets/images/brand-logo.png',
                                  width: 74.w,
                                  height: 74.w,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'كومفورت شوز',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                  // Use Expanded here to constrain the scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            SizedBox(height: 24.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        height: 117.h,
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFF8D2),
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/svg/views.svg",
                                                  width: 20.w,
                                                  height: 14.h,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                'number_of_views'.tr(context),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xff8F95AB),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              cubit.statistics!.recentViews.toString(),
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'watch'.tr(context),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: const Color(0xff8F95AB),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        height: 117.h,
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffDBF7D9),
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/images/svg/user_add.svg",
                                                  width: 20.w,
                                                  height: 14.h,
                                                ),
                                                SizedBox(width: 8.w),
                                                Text(
                                                  'number_of_interactions'.tr(context),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xff8F95AB),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              cubit.statistics!.totalProductLikes.toString()
                                                  ,
                                              style: TextStyle(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              'number_of_sales'.tr(context),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: const Color(0xff8F95AB),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 250.h,
                                    width: double.infinity,
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE3EEFF),
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/svg/advertising_ads.svg",
                                          width: 76.w,
                                          height: 76.h,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              cubit.statistics!.totalSubscriptions.toString(),
                                              style: TextStyle(
                                                fontSize: 32.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'Sponsored_ads'.tr(context),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff8F8F8F),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'number_of_users'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1E2644),
                                  ),
                                ),
                                SizedBox(width: 9.w),
                                Text(
                                  '${DateTime.now().year}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1E2644),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            const DashboardChart(
                              januaryValue: 20,
                              februaryValue: 30,
                              marchValue: 40,
                              aprilValue: 20,
                              mayValue: 0,
                              juneValue:100,
                              julyValue: 80,
                              augustValue: 90,
                              septemberValue: 100,
                              octoberValue: 110,
                              novemberValue: 30,
                              decemberValue: 130,

                            ),
                            SizedBox(height: 24.h),
                             DashboardOverview(
                              totalRevenue: cubit.statistics!.totalRevenue.toString(),
                              imageUrl: cubit.statistics!.mostSoldProduct.image,
                              productName: cubit.statistics!.mostSoldProduct.name,
                              productPersenage: 50,//cubit.statistics!.productPersenage,
                              servicePersenage: 50, //cubit.statistics!.servicepersenage,
                              avgPrice: cubit.statistics!.avgProductPrice.toString()
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'recent_transactions'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1E2644),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    navigateTo(
                                        context, const WalletDetailsScreen());
                                  },
                                  child: Text(
                                    'view_all'.tr(context),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Replace Expanded with a SizedBox or Container with fixed height if needed
                            SizedBox(
                              height: 300.h, // Adjust this height as needed
                              child: ListView(
                                children: [
                                  TransactionItem(
                                    amount: '1000',
                                    isDeposit: true,
                                    description: 'deposit'.tr(context),
                                    date: '15 يوليو 2023, 6:30PM',
                                  ),
                                  TransactionItem(
                                    amount: '500',
                                    isDeposit: false,
                                    description: 'payment_dev_ratio'.tr(context),
                                    date: '15 يوليو 2023, 6:30PM',
                                  ),
                                  TransactionItem(
                                    amount: '1000',
                                    isDeposit: true,
                                    description: 'refund_dev_ratio'.tr(context),
                                    date: '15 يوليو 2023, 6:30PM',
                                  ),
                                  TransactionItem(
                                    amount: '500',
                                    isDeposit: false,
                                    description:
                                        'payment_nasbi_stores'.tr(context),
                                    date: '15 يوليو 2023, 6:30PM',
                                  ),
                                  TransactionItem(
                                    amount: '1000',
                                    isDeposit: true,
                                    description: 'refund_nasbi'.tr(context),
                                    date: '15 يوليو 2023, 6:30PM',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
