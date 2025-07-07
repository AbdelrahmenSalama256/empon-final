import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/order/view/cubit/orders_state.dart';
import 'package:embone/features/client/order/view/widgets/order_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        List<OrderModel> orders = [];
        if (state is OrderLoaded || state is OrderCanceled) {
          orders = context.read<OrdersCubit>().getOrdersByStatus(status);
        }

        if (orders.isEmpty) {
          return Center(child: Text('no_orders'.tr(context)));
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return OrderCard(
              order: {
                'id': order.id,
                'orderNumber': order.orderNumber,
                'date': order.date,
                'quantity': order.quantity,
                'totalPrice': order.totalPrice,
              },
              status: status,
              statusColor: statusColor,
              showCancelButton: showCancelButton,
            );
          },
        );
      },
    );
  }
}
