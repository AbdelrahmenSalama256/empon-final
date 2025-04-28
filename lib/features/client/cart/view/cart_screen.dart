import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/cart/data/model/cart_item_model.dart';
import 'package:embone/features/client/cart/view/widgets/cart_bottom_buttons.dart';
import 'package:embone/features/client/cart/view/widgets/cart_items_list.dart';
import 'package:embone/features/client/checkout/view/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Initialize _cartItems with fake data
  final List<CartItem> _cartItems = [
    CartItem(
      id: "1",
      title: "Blue T-Shirt",
      price: 19.99,
      quantity: 2,
      size: "M",
      category: "Clothing",
      subCategory: "T-Shirts",
      imageUrl:
          "assets/images/test-product.png", // Replace with a valid asset path
    ),
    CartItem(
      id: "2",
      title: "Black Sneakers",
      price: 59.99,
      quantity: 1,
      size: "10",
      category: "Footwear",
      subCategory: "Sneakers",
      imageUrl:
          "assets/images/test-product.png", // Replace with a valid asset path
    ),
    CartItem(
      id: "3",
      title: "Leather Jacket",
      price: 99.99,
      quantity: 1,
      size: "L",
      category: "Clothing",
      subCategory: "Jackets",
      imageUrl:
          "assets/images/test-product.png", // Replace with a valid asset path
    ),
  ];

  void _updateQuantity(int index, int change) {
    setState(() {
      final newQuantity = _cartItems[index].quantity + change;
      if (newQuantity > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
    });
  }

  void _handleMenuPressed(int action, GlobalKey menuKey) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (action == 1) {
          // "Remove" action
          final index = _cartItems.indexWhere(
            (item) => item.id == menuKey.toString(),
          );
          if (index != -1) {
            _cartItems.removeAt(index);
          }
        } else if (action == 0) {
          // "Favorite" action
          // Add to favorites logic here (if implemented)
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            AppHeader(
              title: 'cart_title'.tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
            ),
            Expanded(
              child: _cartItems.isEmpty
                  ? SingleChildScrollView(
                      child: _buildEmptyCartWidget()) // Show empty cart message
                  : Column(
                      children: [
                        CartItemsList(
                          cartItems: _cartItems,
                          onQuantityChanged: _updateQuantity,
                          onMenuPressed: _handleMenuPressed,
                        ),
                        CartBottomButtons(
                          onCheckoutPressed: () {
                            navigateTo(context, const CheckoutScreen());
                          },
                          onContinueShoppingPressed: () {
                            context.read<GlobalCubit>().changeBottomNavIndex(2);
                          },
                        ),
                        SizedBox(height: 30.h),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display when the cart is empty
  Widget _buildEmptyCartWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/empty-cart.png",
              width: 271.w,
              height: 271.h,
            ),
            SizedBox(height: 16.h),
            Text(
              'cart_empty_message'.tr(context),
              style: TextStyle(fontSize: 20.sp, color: const Color(0xff000000)),
            ),
            SizedBox(height: 16.h),
            Text(
              'thanks_for_using_embone'.tr(context),
              style: TextStyle(fontSize: 14.sp, color: const Color(0xffB5BBCF)),
            ),
            SizedBox(height: 16.h),
            AppButton(
              onPressed: () {
                // Navigate to the home screen or continue shopping
                Navigator.pop(context);
              },
              text: 'success_order_back_to_home_button'.tr(context),
            ),
          ],
        ),
      ),
    );
  }
}
