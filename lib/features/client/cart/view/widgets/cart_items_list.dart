import 'package:embone/features/client/cart/data/model/cart_model.dart';
import 'package:embone/features/client/cart/view/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItemModel> cartItems;
  final Function(int, int) onQuantityChanged;
  final Function(int, int, int)
      onMenuPressed; // Updated to accept action, cartItemId, and productId
  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.onQuantityChanged,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final GlobalKey menuKey = GlobalKey();
          return CartItemWidget(
            item: item,
            onQuantityChanged: (change) => onQuantityChanged(index, change),
            onMenuPressed: (action) => onMenuPressed(
              action,
              item.id, // cartItemId
              item.productId, // productId
            ),
            menuKey: menuKey,
          );
        },
      ),
    );
  }
}
