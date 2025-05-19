import 'package:embone/features/client/cart/data/model/cart_model.dart';

class CartState {}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartResponseModel cartResponse;

  CartLoaded(this.cartResponse);
}

class AddToCartSuccess extends CartState {
  final String message;

  AddToCartSuccess(this.message);
}

class CartUpdated extends CartState {
  final String message;

  CartUpdated(this.message);
}

class CartItemRemoved extends CartState {
  final String message;

  CartItemRemoved(this.message);
}

class CartError extends CartState {
  final String error;

  CartError(this.error);
}
