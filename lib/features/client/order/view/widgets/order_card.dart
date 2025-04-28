// ignore_for_file: deprecated_member_use

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/order/view/order_details_screen.dart';
import 'package:flutter/material.dart';
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
  void _showCancelConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('cancel_ask'.tr(context)),
          content: Text('are_you_sure_to_cancel'.tr(context)),
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
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    text: 'yes'.tr(context),
                    type: AppButtonType.secondary,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    text: 'no'.tr(context),
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order : ${widget.order['orderNumber']}',
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

          // Divider
          Divider(height: 1.h, color: Colors.grey[200]),

          // Order Details
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                // Quantity and Total Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity
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

                    // Total Price
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

                SizedBox(height: 16.h),

                // Status and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status
                    Text(
                      widget.status.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: widget.statusColor,
                      ),
                    ),

                    // Actions
                    Row(
                      children: [
                        SizedBox(width: 8.w),
                        SizedBox(
                          width: 100.w,
                          child: AppButton(
                            onPressed: () {
                              navigateTo(context, const OrderDetailsScreen());
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
