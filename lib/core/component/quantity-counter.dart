import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/core/constants/app_colors.dart';

class QuantityCounter extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;
  final int? limit;

  const QuantityCounter({
    super.key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
    this.limit,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _increaseQuantity() {
    if (widget.limit != null) {
      if (quantity < widget.limit!) {
        setState(() {
          quantity++;
        });
        widget.onQuantityChanged(quantity);
      }
    } else {
      setState(() {
        quantity++;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 40.h,
      // width: 120.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1.w),
        borderRadius: BorderRadius.circular(100.r),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon:
                const Icon(CupertinoIcons.minus, color: AppColors.primaryColor),
            onPressed: _decreaseQuantity,
          ),
          Text(
            "$quantity",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: AppColors.primaryColor),
            onPressed: _increaseQuantity,
          ),
        ],
      ),
    );
  }
}
