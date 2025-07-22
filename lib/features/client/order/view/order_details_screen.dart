import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/order/view/widgets/order_details_item.dart';
import 'package:embone/features/client/order/view/widgets/order_details_payment.dart';
import 'package:embone/features/client/order/view/widgets/order_details_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cubit/orders_state.dart';

class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // Fetch order details when the screen is built
    context.read<OrdersCubit>().fetchOrderDetails(orderId);

    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderDetailsError) {
          showToast(
            context,
            message: 'unexpected_error'.tr(context),
            state: ToastStates.error,
          );
        } else if (state is OrderCanceled) {
          showToast(
            context,
            message: state.message.tr(context),
            state: ToastStates.success,
          );
          // Navigate back to MyOrdersScreen after successful cancellation
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final orderDetails = cubit.currentOrderDetails;

        // Find the order status from OrdersCubit to determine if cancel button should be shown
        String? orderStatus;
        final allOrders = [
          ...cubit.deliveredOrders,
          ...cubit.inDeliveryOrders,
          ...cubit.canceledOrders,
          ...cubit.pendingOrders,
        ];
        final order = allOrders.firstWhere(
          (order) => order.id == orderId,
          orElse: () => OrderModel(
            id: orderId,
            orderNumber: '',
            date: '',
            quantity: 0,
            totalPrice: 0,
            status: '',
          ),
        );
        orderStatus = order.status.isNotEmpty ? order.status : null;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: "order_details".tr(context),
                  centerTitle: true,
                  showBackButton: true,
                  onBackPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // // Display Order ID
                // Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                //   child: Text(
                //     '${'order_id'.tr(context)}: #${order.date}',
                //     style: TextStyle(
                //       fontSize: 16.sp,
                //       fontWeight: FontWeight.w600,
                //       color: const Color(0xff222222),
                //     ),
                //   ),
                // ),
                // Display Order Status (if available)
                if (orderStatus != null)
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${'status'.tr(context)}: ${orderStatus.tr(context)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff9B9B9B),
                          ),
                        ),
                        // Cancel Button for pending or in_delivery orders
                        if (orderStatus == 'pending' ||
                            orderStatus == 'in_delivery')
                          ElevatedButton(
                            onPressed: () {
                              cubit.cancelOrder(orderId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffEC4B4B),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 8.h),
                            ),
                            child: Text(
                              'cancel_order'.tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: state is OrderDetailsLoading
                      ? const Center(child: CustomLoadingIndicator())
                      : state is OrderDetailsLoaded && orderDetails != null
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order Items
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: orderDetails.items.length,
                                    itemBuilder: (context, index) {
                                      final item = orderDetails.items[index];
                                      return OrderItem(
                                        name: item.name,
                                        color: item.color,
                                        size: item.size,
                                        price: item.price,
                                        image: item.image,
                                      );
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  // Order Summary
                                  OrderSummary(
                                    subtotal: orderDetails.summary.subtotal,
                                    deliveryFee:
                                        orderDetails.summary.deliveryFee,
                                    total: orderDetails.summary.total,
                                  ),
                                  SizedBox(height: 16.h),
                                  // Payment Method
                                  PaymentMethod(
                                    type: orderDetails.paymentMethod.type,
                                  ),
                                  SizedBox(height: 16.h),
                                ],
                              ),
                            )
                          : Center(
                              child: Text(
                                state is OrderDetailsError
                                    ? state.message.tr(context)
                                    : 'no_data'.tr(context),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
