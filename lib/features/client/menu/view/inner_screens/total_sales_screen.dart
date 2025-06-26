import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SalesStatsPage extends StatefulWidget {
  const SalesStatsPage({super.key});

  @override
  State<SalesStatsPage> createState() => _SalesStatsPageState();
}

class _SalesStatsPageState extends State<SalesStatsPage> {
  int selectedIndex = 0;
  DateTime? selectedDate;
  final List<String> filters = ["شهري", "اسبوعي", "يومي"];
  final Map<int, List<double>> chartData = {
    0: [1200, 900, 1500, 1100, 1600, 1700, 1300], // شهري
    1: [1000, 800, 1200, 1400, 1100, 900, 1300], // اسبوعي
    2: [300, 700, 200, 400, 600, 500, 100], // يومي
  };
String selectedDateRange = 'اختر المدة';
final List<String> dateRanges = [
    'اختر المدة',
    'هذا الاسبوع',
    'آخر ٧ أيام',
    'هذا الشهر',
    'تاريخ مخصص',
  ];
  DateTimeRange? customRange;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatCard(
                color: const Color(0xffe0efff),
                icon: Icons.attach_money_rounded,
                title: 'إجمالي المبيعات من خلال امبون',
                value: '1000.000 ج.م',
              ),
              const SizedBox(height: 12),
              _buildStatCard(
                color: const Color(0xffd9f5e4),
                icon: Icons.inventory_2_outlined,
                title: 'عدد الطلبات من خلال امبون',
                value: '1500',
              ),
              const SizedBox(height: 12),
              ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("اختيار تاريخ"),
              ),
              
              const SizedBox(height: 12),
              _buildToggleButtons(),
              const SizedBox(height: 12),
              _buildBarChart(),
            ],
          ),
        ),
      ),
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
                  style:  TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (child != null) ...[
                  const SizedBox(height: 8),
                  child,
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildToggleButtons() {
    return Container(
      height: 48,
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
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
  
Widget _buildBarChart() {
    final selectedData = chartData[selectedIndex] ?? [];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 2200,
          barGroups: List.generate(
            selectedData.length,
            (i) => _barGroup(i, selectedData[i]),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
        ),
      ),
    );
  }

BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 12,
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

// Widget _buildDateRangeDropdown() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: DropdownButtonFormField<String>(
//         value: selectedDateRange,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.grey[100],
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//           contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//         items: dateRanges.map((range) {
//           return DropdownMenuItem<String>(
//             value: range,
//             child: Text(range, style: TextStyle(fontSize: 16)),
//           );
//         }).toList(),
//         onChanged: (value) async {
//           if (value == null) return;

//           setState(() {
//             selectedDateRange = value;
//           });

//           if (value == 'تاريخ مخصص') {
//             final picked = await showDateRangePicker(
//               context: context,
//               firstDate: DateTime(2023),
//               lastDate: DateTime.now(),
//               saveText: 'تم',
//               builder: (context, child) => Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: ColorScheme.light(
//                     primary: Colors.blue,
//                     onPrimary: Colors.white,
//                     surface: Colors.white,
//                     onSurface: Colors.black,
//                   ),
//                 ),
//                 child: child!,
//               ),
//             );

//             if (picked != null) {
//               setState(() {
//                 customRange = picked;
//                 selectedDateRange =
//                     "${picked.start.toLocal().toString().split(' ')[0]} - ${picked.end.toLocal().toString().split(' ')[0]}";
//               });
//             }
//           }

//           // 🔄 Here you would trigger filtering chart data
//           // Example: filterChartData(selectedDateRange, customRange);
//         },
//       ),
//     );
//   }

String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

}
