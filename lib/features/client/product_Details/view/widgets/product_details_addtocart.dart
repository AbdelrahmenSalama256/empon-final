import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AddToCartButton extends StatelessWidget {
  final int productId;
  final int variationId;
  final int quantity;
  final String type;
  final String? phone;
  final String? selectedSize;
  final Color? selectedColor;
  final String? productName;
  final String? imageUrl;

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.variationId,
    required this.quantity,
    this.phone,
    required this.type,
    this.selectedSize,
    this.selectedColor,
    this.productName,
    this.imageUrl,
  });

  String _getWhatsAppMessage(BuildContext context) {
    final colorValue = selectedColor?.value
        .toRadixString(16)
        .padLeft(8, '0')
        .substring(2)
        .toUpperCase();
    final colorText =
        '${'color'.tr(context)}: ${colorValue != null ? '#$colorValue' : 'not_selected'.tr(context)}';
    final sizeText =
        '${'size'.tr(context)}: ${selectedSize ?? 'not_selected'.tr(context)}';

    return '''
${'whatsapp_order_intro'.tr(context)}
${'product_name'.tr(context)}: ${productName ?? 'unknown_product'.tr(context)}
${'product_id'.tr(context)}: $productId
${'image_url'.tr(context)}: ${imageUrl ?? 'no_image_available'.tr(context)}
${'quantity'.tr(context)}: $quantity
$sizeText
$colorText
${'confirm_request'.tr(context)}
''';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<CartRepo>()),
      child: BlocListener<CartCubit, CartState>(
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
        child: type == "store"
            ? AppButton(
                onPressed: () {
                  context.read<CartCubit>().addProductToCart(
                        productId: productId,
                        variationId: variationId,
                        quantity: quantity,
                      );
                },
                text: 'add_to_cart'.tr(context),
              )
            : AppButton(
                onPressed: () async {
                  final message = _getWhatsAppMessage(context);
                  final whatsappUrl =
                      'https://wa.me/+2${phone ?? ''}?text=${Uri.encodeComponent(message)}';
                  if (await canLaunch(whatsappUrl)) {
                    await launch(whatsappUrl);
                  } else {
                    showToast(
                      context,
                      message: 'could_not_launch_whatsapp'.tr(context),
                      state: ToastStates.error,
                    );
                  }
                },
                text: 'via_whatsapp'.tr(context),
              ),
      ),
    );
  }
}
