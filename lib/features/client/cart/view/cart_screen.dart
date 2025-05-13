import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/widgets/cart_bottom_buttons.dart';
import 'package:embone/features/client/cart/view/widgets/cart_items_list.dart';
import 'package:embone/features/client/checkout/view/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<CartRepo>())..fetchCart(),
      child: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is AddToCartSuccess) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
          if (state is CartUpdated) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          }
          if (state is CartItemRemoved) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.success,
            );
          } else if (state is CartError) {
            showToast(
              context,
              message: state.error.tr(context),
              state: ToastStates.error,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<CartCubit>();
          final cartItems = cubit.cartItems;

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
                    child: cartItems.isEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              cubit.fetchCart();
                            },
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: _buildEmptyCartWidget(context),
                            ),
                          )
                        : ModalProgressHUD(
                            inAsyncCall: state is CartLoading,
                            child: RefreshIndicator(
                              onRefresh: () async {
                                cubit.fetchCart();
                              },
                              child: Column(
                                children: [
                                  CartItemsList(
                                    cartItems:
                                        cartItems, // Pass CartItemModel list directly
                                    onQuantityChanged: (index, change) {
                                      final newQuantity =
                                          cartItems[index].quantity + change;
                                      if (newQuantity > 0) {
                                        cubit.updateCartItemQuantity(
                                          cartItemId: cartItems[index].id,
                                          quantity: newQuantity,
                                        );
                                      }
                                    },
                                    onMenuPressed:
                                        (action, cartItemId, productId) {
                                      if (action == 1) {
                                        // "Remove" action - Use cartItemId
                                        cubit.removeCartItem(cartItemId);
                                      } else if (action == 0) {
                                        // "Add to Favorites" action - Use productId
                                        context
                                            .read<GlobalCubit>()
                                            .addProductToWishlist(productId);
                                      }
                                    },
                                  ),
                                  CartBottomButtons(
                                    onCheckoutPressed: () {
                                      navigateTo(
                                          context, const CheckoutScreen());
                                    },
                                    onContinueShoppingPressed: () {
                                      context
                                          .read<GlobalCubit>()
                                          .changeBottomNavIndex(2);
                                    },
                                  ),
                                  SizedBox(height: 30.h),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCartWidget(BuildContext context) {
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
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
              text: 'success_order_back_to_home_button'.tr(context),
            ),
          ],
        ),
      ),
    );
  }
}
