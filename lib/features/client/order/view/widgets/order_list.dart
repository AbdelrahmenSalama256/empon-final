import 'package:embone/features/client/order/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersList extends StatelessWidget {
  final String status;
  final Color statusColor;
  final bool showCancelButton;

  const OrdersList({
    super.key,
    required this.status,
    required this.statusColor,
    required this.showCancelButton,
  });

  @override
  Widget build(BuildContext context) {
    // Sample orders data
    final List<Map<String, dynamic>> orders = [
      {
        'orderNumber': '1947034',
        'date': '05-12-2019',
        'quantity': 3,
        'totalPrice': 2500.00,
      },
      {
        'orderNumber': '1947034',
        'date': '05-12-2019',
        'quantity': 3,
        'totalPrice': 2500.00,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          order: order,
          status: status,
          statusColor: statusColor,
          showCancelButton: showCancelButton,
        );
      },
    );
  }
}
