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

  const DashboardOverview({super.key, required this.totalRevenue, required this.imageUrl, required this.productName, required this.productPersenage, required this.servicePersenage, required this.avgPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 16,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              _buildStatCard(
                context,
                color: const Color(0xFFFFF4D6),
                icon: Icons.inventory_2_outlined,
                amount: avgPrice,
                label: 'average_order_value'.tr(context),
                textColor: Colors.orange[800]!,
              ),
              _buildStatCard(
                context,
                color: const Color(0xFFDFF5E3),
                icon: Icons.account_balance,
                amount: totalRevenue,
                label: 'total_revenue'.tr(context),
                textColor: Colors.green[800]!,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCategoryChart(context,productPersenage, servicePersenage),
              _buildMostSoldProductCard(context, imageUrl, productName),
              
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,{
    required Color color,
    required IconData icon,
    required String amount,
    required String label,
    required Color textColor,

  }) {
    return Container(
      width: 170,
      height: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(height: 8),
          Text(
            "$amount ${'pound'.tr(context)}",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMostSoldProductCard(BuildContext context, String imageUrl, String productName) {
    return Container(
      width: 170,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'best_selling_product'.tr(context),
            style: TextStyle(
              color: Colors.orange[800],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl,
                width: double.infinity,
                height: 130.h,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: 20.h,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Text(productName,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            
          ]
          ),
          
        ],
      ),
    );
  }

  Widget _buildCategoryChart(BuildContext context ,int productPersenage, int servicePersenage) {
    return Container(
      width: 170,
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F6E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'sales_by_category'.tr(context),
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 80.h,
            child: Center(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 25.w,
                  sectionsSpace : 1,
                   sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: productPersenage.toDouble(),
                      title: '$productPersenage%',
                      radius: 28,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: Colors.green[200],
                      value: servicePersenage.toDouble(),
                      title: '$servicePersenage%',
                      radius: 28,
                      titleStyle: const TextStyle(color: Colors.white),
                    ),
                  ],
                  ),
              ),
            ),
          ),
          const SizedBox(height: 20),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             _LegendItem(label: 'products'.tr(context), color: Colors.greenAccent),
              SizedBox(width: 2.w,),
              _LegendItem(label: 'servises'.tr(context), color: Colors.green),
              ],
          )
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
          decoration: BoxDecoration(shape: BoxShape.circle ,color: color),
        ),
         SizedBox(width: 5.w),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
