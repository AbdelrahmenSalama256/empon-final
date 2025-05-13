part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final CartResponseModel cartResponse;

  const CartLoaded(this.cartResponse);
}

class AddToCartSuccess extends CartState {
  final String message;

  const AddToCartSuccess(this.message);
}

class CartUpdated extends CartState {
  final String message;

  const CartUpdated(this.message);
}

class CartItemRemoved extends CartState {
  final String message;

  const CartItemRemoved(this.message);
}

class CartError extends CartState {
  final String error;

  const CartError(this.error);
}
