import 'package:embone/core/locale/app_loacl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardOverview extends StatelessWidget {
  final String totalRevenue;
  final String imageUrl;
  final String productName;
  final int productPersenage;
  final int servicePersenage;
  final String avgPrice;

  const DashboardOverview({
    super.key,
    required this.totalRevenue,
    required this.imageUrl,
    required this.productName,
    required this.productPersenage,
    required this.servicePersenage,
    required this.avgPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize:
            MainAxisSize.min, // Prevent Column from taking extra space
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  color: const Color(0xFFFFF4D6),
                  icon: Icons.inventory_2_outlined,
                  amount: avgPrice,
                  label: 'average_order_value'.tr(context),
                  textColor: Colors.orange[800]!,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  context,
                  color: const Color(0xFFDFF5E3),
                  icon: Icons.account_balance,
                  amount: totalRevenue,
                  label: 'total_revenue'.tr(context),
                  textColor: Colors.green[800]!,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(
              //   child: _buildCategoryChart(
              //       context, productPersenage, servicePersenage),
              // ),
              // SizedBox(width: 12.w),
              Expanded(
                child:
                    _buildMostSoldProductCard(context, imageUrl, productName),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required Color color,
    required IconData icon,
    required String amount,
    required String label,
    required Color textColor,
  }) {
    return Container(
      height: 130.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            "$amount ${'pound'.tr(context)}",
            style: TextStyle(
              color: textColor,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis, // Handle long amounts
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 2, // Prevent overflow for long labels
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMostSoldProductCard(
      BuildContext context, String imageUrl, String productName) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'best_selling_product'.tr(context),
            style: TextStyle(
              color: Colors.orange[800],
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/placeholder.png', // Add a placeholder
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 20.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    productName,
                    style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart(
      BuildContext context, int productPersenage, int servicePersenage) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F6E8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Text(
            'sales_by_category'.tr(context),
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 25.w,
                sectionsSpace: 1,
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: productPersenage.toDouble(),
                    title: '$productPersenage%',
                    radius: 28.r,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                  PieChartSectionData(
                    color: Colors.green[200],
                    value: servicePersenage.toDouble(),
                    title: '$servicePersenage%',
                    radius: 28.r,
                    titleStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendItem(
                label: 'products'.tr(context),
                color: Colors.green,
              ),
              SizedBox(width: 10.w),
              _LegendItem(
                label: 'services'.tr(context), // Fixed typo 'servises'
                color: Colors.green[200]!,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;

  const _LegendItem({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp), // Reduced font size
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
