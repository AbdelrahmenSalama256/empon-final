import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
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
    return BlocConsumer<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderDetailsError) {
          showToast(
            context,
            message: state.message.tr(context),
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<OrdersCubit>();
        final orderDetails = cubit.currentOrderDetails;
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
                  child: state is OrderDetailsLoading
                      ? const Center(child: CustomLoadingIndicator())
                      : state is OrderDetailsLoaded
                          ? SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order Items
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: orderDetails?.items.length,
                                    itemBuilder: (context, index) {
                                      final item = orderDetails?.items[index];
                                      return OrderItem(
                                        name: item!.name,
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
                                    subtotal:
                                        orderDetails?.summary.subtotal ?? 0.0,
                                    deliveryFee:
                                        orderDetails?.summary.deliveryFee ?? 0,
                                    total: orderDetails?.summary.total ?? 0,
                                  ),
                                  SizedBox(height: 16.h),
                                  // Payment Method
                                  PaymentMethod(
                                    type:
                                        orderDetails?.paymentMethod.type ?? "",
                                  ),
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
