import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:embone/core/locale/app_loacl.dart';

class DashboardChart extends StatelessWidget {
  const DashboardChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            offset: Offset(0, 1),
            blurRadius: 20,
            spreadRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heartbeat icon with translated title
          Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xffF7F9FD),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SvgPicture.asset(
              "assets/images/svg/chart.svg",
              width: 20.w,
              height: 18.h,
            ),
          ),
          SizedBox(height: 16.h),

          // Chart
          SizedBox(
            height: 200.h,
            child: SfCartesianChart(
              plotAreaBorderWidth: 0,
              crosshairBehavior: CrosshairBehavior(
                enable: true,
                activationMode: ActivationMode.longPress,
                lineColor: AppColors.primaryColor,
                shouldAlwaysShow: true,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: true,
                color: AppColors.primaryColor,
                borderWidth: 0,
                textStyle: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
                format:
                    'point.y ${'currency'.tr(context)}', // Add currency translation
              ),

              // Primary X Axis (Months)
              primaryXAxis: CategoryAxis(
                opposedPosition: false,
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff8F8F8F),
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
              ),

              // Primary Y Axis (Values)
              primaryYAxis: NumericAxis(
                opposedPosition: true,
                minimum: 0,
                maximum: 150,
                interval: 50,
                majorGridLines: MajorGridLines(
                  width: 1.w,
                  color: const Color(0xFFEEEEEE),
                  dashArray: const <double>[5, 5],
                ),
                axisLine: const AxisLine(width: 0),
                majorTickLines: const MajorTickLines(size: 0),
                labelStyle: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff8F8F8F),
                ),
              ),

              series: <CartesianSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource:
                      getChartData(context), // Pass context for translations
                  xValueMapper: (ChartData data, _) =>
                      data.month.tr(context), // Translate month names
                  yValueMapper: (ChartData data, _) => data.value,
                  pointColorMapper: (ChartData data, _) => data.isHighlighted
                      ? const Color(0xff7BB2FF)
                      : const Color(0xffE9F2FF),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4.r),
                  ),
                  width: 0.5.w,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<ChartData> getChartData(BuildContext context) {
    return [
      ChartData('january'.tr(context), 50, false),
      ChartData('february'.tr(context), 60, false),
      ChartData('march'.tr(context), 90, false),
      ChartData('april'.tr(context), 80, false),
      ChartData('may'.tr(context), 100, false),
      ChartData('june'.tr(context), 70, false),
      ChartData('july'.tr(context), 120, true), // Highlighted bar
      ChartData('august'.tr(context), 40, false),
      ChartData('september'.tr(context), 35, false),
      ChartData('october'.tr(context), 75, false),
      ChartData('november'.tr(context), 30, false),
      ChartData('december'.tr(context), 20, false),
    ];
  }
}

class ChartData {
  final String month;
  final double value;
  final bool isHighlighted;

  const ChartData(this.month, this.value, this.isHighlighted);
}
