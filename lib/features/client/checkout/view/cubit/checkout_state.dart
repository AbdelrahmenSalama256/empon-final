import 'package:embone/features/client/checkout/data/model/cart_info_model.dart';

class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final CartInfoModel cartInfo;

  CheckoutLoaded(this.cartInfo);
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError(this.message);
}
