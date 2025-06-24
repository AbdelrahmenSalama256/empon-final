import 'package:flutter/material.dart';

class PlanSection extends StatefulWidget {
  const PlanSection({super.key});

  @override
  State<PlanSection> createState() => _PlanSectionState();
}

class _PlanSectionState extends State<PlanSection> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final plans = [
      {
        'title': "الخطة الأساسية",
        'color': Colors.green,
        'details': [
          "عدد المنتجات: 1 منتج",
          "المدة: 3 أيام",
          "المميزات:",
          "يظهر في أول القائمة للزوار.",
          "شعار \"ممول\" على المنتج.",
          "السعر المقترح: 20 جنيه",
        ],
      },
      {
        'title': "الخطة الاقتصادية",
        'color': Colors.blue,
        'details': [
          "عدد المنتجات: 3 منتجات",
          "المدة: 6 أيام",
          "المميزات:",
          "الظهور في نتائج البحث.",
          "زيادات عدد المشاهدات.",
          "السعر المقترح: 50 جنيه",
        ],
      },
      {
        'title': "خطة المحترفين",
        'color': Colors.red,
        'details': [
          "عدد المنتجات: 10 منتجات",
          "المدة: 14 يوم",
          "المميزات:",
          "تحليلات وتصنيف للأداء.",
          "الظهور في الصفحة الرئيسية للمستخدمين.",
          "دعم فني مباشر.",
          "السعر المقترح: 150 جنيه",
        ],
      },
    ];

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "خطط ترويج العمل",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < plans.length; i++)
            _buildPlanTile(
              index: i,
              title: plans[i]['title'] as String,
              color: plans[i]['color'] as Color,
              details: plans[i]['details'] as List<String>,
            ),
        ],
      ),
    );
  }

  Widget _buildPlanTile({
    required int index,
    required String title,
    required Color color,
    required List<String> details,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ExpansionTile(
        collapsedIconColor: color,
        iconColor: color,
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: expandedIndex == index,
        onExpansionChanged: (expanded) {
          if (expandedIndex != (expanded ? index : null)) {
            setState(() {
              expandedIndex = expanded ? index : null;
            });
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var item in details)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text("• $item",
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                        )),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("اختيار الخطة"),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
