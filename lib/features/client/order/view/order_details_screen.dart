import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/order/view/widgets/order_details_item.dart';
import 'package:embone/features/client/order/view/widgets/order_details_payment.dart';
import 'package:embone/features/client/order/view/widgets/order_details_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample order items
    final List<Map<String, dynamic>> orderItems = [
      {
        'name': 'Orlando Athletic Shoes',
        'color': 'White',
        'size': '39',
        'price': 900.00,
        'image': 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb',
      },
      {
        'name': 'Orlando Athletic Shoes',
        'color': 'Blue',
        'size': '39',
        'price': 900.00,
        'image': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
      },
    ];

    // Order summary
    final Map<String, dynamic> orderSummary = {
      'subtotal': 2350.00,
      'deliveryFee': 50.00,
      'total': 2400.00,
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "order_details".tr(context),
              centerTitle: true,
              showBackButton: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orderItems.length,
                      itemBuilder: (context, index) {
                        final item = orderItems[index];
                        return OrderItem(
                          name: item['name'],
                          color: item['color'],
                          size: item['size'],
                          price: item['price'],
                          image: item['image'],
                        );
                      },
                    ),

                    SizedBox(height: 16.h),

                    // Order Summary
                    OrderSummary(
                      subtotal: orderSummary['subtotal'],
                      deliveryFee: orderSummary['deliveryFee'],
                      total: orderSummary['total'],
                    ),

                    SizedBox(height: 16.h),

                    // Payment Method
                    const PaymentMethod(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
