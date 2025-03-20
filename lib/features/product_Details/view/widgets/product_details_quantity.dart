import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelectorSection extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;

  const QuantitySelectorSection({
    Key? key,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quantity controls (start side)
          Row(
            children: [
              // Decrease button
              _QuantityButton(
                icon: Icons.remove,
                onPressed: () {
                  if (quantity > 1) {
                    onQuantityChanged(quantity - 1);
                  }
                },
              ),

              // Quantity display
              Container(
                width: 40.w,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              // Increase button
              _QuantityButton(
                icon: Icons.add,
                onPressed: () {
                  onQuantityChanged(quantity + 1);
                },
              ),
            ],
          ),

          // Quantity label (end side)
          Text(
            'الكمية',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Icon(
          icon,
          size: 16.w,
          color: Colors.black,
        ),
      ),
    );
  }
}
