import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddToCartButton extends StatelessWidget {
  int productId;
  int variationId;
  int quantity;
  AddToCartButton({
    super.key,
    required this.productId,
    required this.variationId,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is AddToCartSuccess) {
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
      child: AppButton(
        onPressed: () {
          context.read<CartCubit>().addProductToCart(
                productId: productId,
                variationId: variationId,
                quantity: quantity,
              );
        },
        text: 'add_to_cart'.tr(context),
      ),
    );
  }
}
