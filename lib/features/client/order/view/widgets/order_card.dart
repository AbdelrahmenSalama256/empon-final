import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/order/view/cubit/orders_state.dart';
import 'package:embone/features/client/order/view/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final String status;
  final Color statusColor;
  final bool showCancelButton;

  const OrderCard({
    super.key,
    required this.order,
    required this.status,
    required this.statusColor,
    required this.showCancelButton,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
   String? _selectedStatus;

  @override
  void initState() {
    super.initState();
  }

  void _showCancelConfirmationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('cancel_ask'.tr(parentContext)),
          content: Text('are_you_sure_to_cancel'.tr(parentContext)),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    height: 30.h,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      parentContext
                          .read<OrdersCubit>()
                          .cancelOrder(widget.order['id']);
                    },
                    text: 'yes'.tr(parentContext),
                    type: AppButtonType.secondary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    text: 'no'.tr(parentContext),
                    type: AppButtonType.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    height: 30.h,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersCubit, OrdersState>(
      listener: (context, state) {
        if (state is OrderCanceled) {
          showToast(context,
              message: state.message, state: ToastStates.success);
        } else if (state is OrderError) {
          showToast(context, message: state.message, state: ToastStates.error);
        } else if (state is OrderUpdateError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }  if (state is OrderUpdateLoaded) {
          showToast(context, message: 'order_update_success'.tr(context), state: ToastStates.error);
          context.read<OrdersCubit>().fetchAccountOrders();
        }  if (state is OrderUpdateLoading) {
          isloading = true;

        }
      },
      child: isloading
          ? const  Center(child: CircularProgressIndicator())
          : Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'order'.tr(context)}: ${widget.order['orderNumber']}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    widget.order['date'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xff9B9B9B),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1.h, color: Colors.grey[200]),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'quantity'.tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff9B9B9B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${widget.order['quantity']}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: const Color(0xff222222),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'total_price'.tr(context),
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff9B9B9B),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                            Text(
                              '\$${widget.order['totalPrice'].toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xff222222),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    Visibility(
                      visible: context.read<GlobalCubit>().userType == UserType.business,
                      child: DropdownButtonFormField<String>(
                        hint:  Text(
                              _selectedStatus ??
                                  'update_order_status'.tr(context), style: const TextStyle(
                          color: AppColors.primaryColor,
                        ),),
                        //value: _selectedStatus,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(45.r),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: "pending",
                            child: Text("pending".tr(context)),
                          ),
                          DropdownMenuItem(
                            value: "delivered",
                            child: Text("delivered".tr(context)),
                          ),
                          DropdownMenuItem(
                            value: "cancelled",
                            child: Text("cancelled".tr(context)),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value!;
                            context.read<OrdersCubit>().updateOrederStatus(widget.order['id'], value);

                          });
                          // Add your logic here if you want to handle the value change
                        },
                      ),
                    ),
                    
              Visibility(
                visible: context.read<GlobalCubit>().userType ==
                          UserType.business,
                child: SizedBox(height: 12.h)),
                    
                  Visibility(
                    visible: context.read<GlobalCubit>().userType ==
                        UserType.client,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.status.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: widget.statusColor,
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(width: 8.w),
                            SizedBox(
                              width: 100.w,
                              child: AppButton(
                                onPressed: () {
                                  navigateTo(
                                      context,
                                      BlocProvider(
                                        create: (context) => OrdersCubit(
                                            sl<OrderRepo>())
                                          ..fetchOrderDetails(widget.order['id']),
                                        child: OrderDetailsScreen(
                                            orderId: widget.order['id']),
                                      ));
                                },
                                type: AppButtonType.secondary,
                                borderRadius: BorderRadius.circular(100.r),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 5.h,
                                ),
                                borderColor: const Color(0xff222222),
                                height: 30.h,
                                text: 'details'.tr(context),
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff222222),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            if (widget.showCancelButton)
                              SizedBox(
                                width: 100.w,
                                child: AppButton(
                                  onPressed: () {
                                    _showCancelConfirmationDialog(context);
                                  },
                                  borderColor: const Color(0xffEC4B4B),
                                  type: AppButtonType.secondary,
                                  borderRadius: BorderRadius.circular(100.r),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                    vertical: 5.h,
                                  ),
                                  height: 30.h,
                                  text: 'cancel'.tr(context),
                                  textStyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xffEC4B4B),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        
                      ],
                    ),
                  ),
                  Visibility(
                    visible: context.read<GlobalCubit>().userType ==
                          UserType.business,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        
                        Row(
                          children: [
                            SizedBox(width: 8.w),
                            SizedBox(
                              width: 100.w,
                              child: AppButton(
                                onPressed: () {
                                  navigateTo(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            OrdersCubit(sl<OrderRepo>())
                                              ..fetchOrderDetails(
                                                  widget.order['id']),
                                        child: OrderDetailsScreen(
                                            orderId: widget.order['id']),
                                      ));
                                },
                                type: AppButtonType.secondary,
                                borderRadius: BorderRadius.circular(100.r),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.w,
                                  vertical: 5.h,
                                ),
                                borderColor: const Color(0xff222222),
                                height: 30.h,
                                text: 'details'.tr(context),
                                textStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff222222),
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                        Text(
                          widget.status.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: widget.statusColor,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
