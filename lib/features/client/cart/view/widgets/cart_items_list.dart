import 'package:embone/features/client/cart/data/model/cart_item_model.dart';
import 'package:embone/features/client/cart/view/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemsList extends StatelessWidget {
  final List<CartItem> cartItems;
  final Function(int, int) onQuantityChanged;
  final Function(int, GlobalKey) onMenuPressed;
  const CartItemsList({
    super.key,
    required this.cartItems,
    required this.onQuantityChanged,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    //  if(cartItems.isEmpty){
    //   return Scaffold(body: EmptyCartWidget());
    //  }
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          final GlobalKey menuKey = GlobalKey(); // Unique key for each item
          return CartItemWidget(
            item: item,
            onQuantityChanged: (change) => onQuantityChanged(index, change),
            onMenuPressed: (action, key) =>
                onMenuPressed(action, menuKey), // Pass menuKey
            menuKey: menuKey,
          );
        },
      ),
    );
  }
}
