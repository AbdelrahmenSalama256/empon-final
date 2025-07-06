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
    final businessId = context.read<GlobalCubit>().businessId;
    final account = context
        .read<GlobalCubit>()
        .userAccount!
        .firstWhere((acc) => acc.id == businessId);
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await context
                .read<StatisticsCubit>()
                .fetchStatistics(context.read<GlobalCubit>().businessId);
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.r),
                              border: Border.all(
                                  color: AppColors.grey, width: 0.2.w),
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
                                child: cubit.statistics!.account.name != null
                                    ? Image.network(
                                        cubit.statistics!.account.logo,
                                        width: 74.w,
                                        height: 74.w,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'assets/images/brand-logo.png',
                                          width: 74.w,
                                          height: 74.w,
                                        ),
                                      )
                                    : Image.asset(
                                        'assets/images/brand-logo.png',
                                        width: 74.w,
                                        height: 74.w,
                                      ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              cubit.statistics!.account.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
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
                                        height: 130.h, // Increased from 117.h
                                        padding: EdgeInsets.all(16.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffFFF8D2),
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              cubit.statistics!.recentViews
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize:
                                                    24.sp, // Reduced from 30.sp
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'watch'.tr(context),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: const Color(0xff8F95AB),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Container(
                                        height: 130.h, // Increased from 117.h
                                        padding: EdgeInsets.all(12.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffDBF7D9),
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                  'number_of_interactions'
                                                      .tr(context),
                                                  style: TextStyle(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        const Color(0xff8F95AB),
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8.h),
                                            Text(
                                              cubit
                                                  .statistics!.totalProductLikes
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize:
                                                    24.sp, // Reduced from 30.sp
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'number_of_sales'.tr(context),
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: const Color(0xff8F95AB),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                              cubit.statistics!
                                                  .totalSubscriptions
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 32.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Sponsored_ads'.tr(context),
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff8F8F8F),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 9.w),
                                Text(
                                  '${DateTime.now().year}',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1E2644),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            DashboardChart(
                              januaryValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'january'.tr(context)] ??
                                      0,
                              februaryValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'february'.tr(context)] ??
                                      0,
                              marchValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'march'.tr(context)] ??
                                      0,
                              aprilValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'april'.tr(context)] ??
                                      0,
                              mayValue: cubit.statistics!.visitorsCountForYear[
                                      'may'.tr(context)] ??
                                  0,
                              juneValue: cubit.statistics!.visitorsCountForYear[
                                      'june'.tr(context)] ??
                                  0,
                              julyValue: cubit.statistics!.visitorsCountForYear[
                                      'july'.tr(context)] ??
                                  0,
                              augustValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'august'.tr(context)] ??
                                      0,
                              septemberValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'september'.tr(context)] ??
                                      0,
                              octoberValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'october'.tr(context)] ??
                                      0,
                              novemberValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'november'.tr(context)] ??
                                      0,
                              decemberValue:
                                  cubit.statistics!.visitorsCountForYear[
                                          'december'.tr(context)] ??
                                      0,
                            ),
                            SizedBox(height: 24.h),
                            account.isStore != 0
                                ? DashboardOverview(
                                    totalRevenue: cubit.statistics!.totalRevenue
                                        .toString(),
                                    imageUrl:
                                        "${cubit.statistics?.mostSoldProduct?.image}",
                                    productName:
                                        "${cubit.statistics?.mostSoldProduct?.name}",
                                    productPersenage: 50,
                                    servicePersenage: 50,
                                    avgPrice: cubit.statistics!.avgProductPrice
                                        .toString(),
                                  )
                                : const SizedBox(),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                cubit.statistics!.walletTransactions.isNotEmpty
                                    ? InkWell(
                                        onTap: () {
                                          navigateTo(context,
                                              const WalletDetailsScreen());
                                        },
                                        child: Text(
                                          'view_all'.tr(context),
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.primary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 300.h,
                              child: cubit
                                      .statistics!.walletTransactions.isEmpty
                                  ? Center(
                                      child: Text(
                                        'no_transactions_found'.tr(context),
                                        style: TextStyle(fontSize: 14.sp),
                                      ),
                                    )
                                  : ListView(
                                      children: [
                                        for (final transaction in cubit
                                            .statistics!.walletTransactions)
                                          TransactionItem(
                                            amount:
                                                transaction.amount.toString(),
                                            description: transaction.type,
                                            date: transaction.createdAt
                                                .toString(),
                                            isDeposit: true,
                                          ),
                                      ],
                                    ),
                            ),
                            SizedBox(height: 20.h), // Extra padding at bottom
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
