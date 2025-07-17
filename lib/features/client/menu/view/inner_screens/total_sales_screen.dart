import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_hero.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart';
import 'package:embone/features/client/menu/view/cubit/total_sales_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/total_sales_state.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesStatsPage extends StatefulWidget {
  const SalesStatsPage({super.key});

  @override
  State<SalesStatsPage> createState() => _SalesStatsPageState();
}

class _SalesStatsPageState extends State<SalesStatsPage> {
  int selectedIndex = 0;
  DateTime? selectedDate;

  String get selectedDateString {
    if (selectedDate == null) return '';
    return '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}';
  }

  final List<String> filters = ['daily', 'monthly', 'yearly'];
  final List<String> filterTypes = ['day', 'month', 'year'];

  Map<String, double> chartResponseData = {};

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TotalSalesCubit>();
    final accountCubit = context.read<BusinessAccountCubit>();
    return BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: state is BusinessAccountLoading
              ? const Center(child: CircularProgressIndicator())
              :BlocBuilder<TotalSalesCubit, TotalSalesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeStoreHeader(
                    isVendor: true,
                    name: accountCubit.accountData!.data.name,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 8),
                  HomeStoreHero(
                      storeLogo: accountCubit.accountData?.data.logo,
                      storeCover: accountCubit.accountData?.data.cover),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HomeStoreNameSection(
                      isVerified: accountCubit.accountData!.data.verified!,
                      name: "${accountCubit.accountData?.data.name}",
                      onTap: () {
                        accountCubit.launchLocationUrl(
                            latitude: double.parse(
                                accountCubit.accountData!.data.lat!),
                            longitude: double.parse(
                                accountCubit.accountData!.data.lng!));
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "sales_instruction_top".tr(context),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "sales_instruction_date".tr(context),
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                  _buildStatCard(
                    color: const Color(0xffe0efff),
                    icon: Icons.attach_money_rounded,
                    title: 'total_sales_embon'.tr(context),
                    value: cubit.totalSales?.deliveredOrdersAmount != null
                        ? '${cubit.totalSales!.deliveredOrdersAmount} ${'pound'.tr(context)}'
                        : '',
                  ),
                  SizedBox(height: 12.h),
                  _buildStatCard(
                    color: const Color(0xffd9f5e4),
                    icon: Icons.inventory_2_outlined,
                    title: 'number_orders_embon'.tr(context),
                    value: cubit.totalSales?.deliveredOrdersAmount != null
                        ? '${cubit.totalSales!.deliveredOrdersCount}'
                        : "",
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2023),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    text: "choose_date".tr(context),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 48.h,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(filters.length, (index) {
                        final isSelected = selectedIndex == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                            cubit.fetchTotalSales(
                                filterTypes[index], selectedDateString);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              filters[index].tr(context),
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildBarChart(
                    cubit.totalSales?.chart != null
                        ? cubit.totalSales!.chart.keys.toList()
                        : [],
                    cubit.totalSales?.chart != null
                        ? cubit.totalSales!.chart.values.toList()
                        : [],
                  ),
                ],
              ),
            ),
          ),
        );}
        ));
      },
    );
  }

  Widget _buildStatCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    Widget? child,
  }) {
    return Container(
      height: 150.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36.sp, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (child != null) ...[
                  SizedBox(height: 8.h),
                  child,
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(
    List key,
    List value,
  ) {
    final keys = key;
    final values = value.map((e) => (e as num).toDouble()).toList();

    return SizedBox(
      height: 300.h,
      child: BarChart(
        BarChartData(
            maxY: values.isEmpty
              ? 1000.0
              : values.reduce((a, b) => a > b ? a : b) + 200.0,
          alignment: BarChartAlignment.spaceAround,
          barGroups: List.generate(
            values.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: values[index],
                  width: 10.w,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 14.h,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Transform.rotate(
                      angle: -45,
                      child: Text(
                        keys.length > index ? keys[index] : '',
                        style: TextStyle(fontSize: 7.sp),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1000,
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: true),
        ),
      ),
    );
  }
}
