import '../../data/model/order_response_model.dart';
import '../../data/model/payment_url_response_model.dart';

class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutLoaded extends CheckoutState {
  final OrderResponseModel cartInfo;

  CheckoutLoaded(this.cartInfo);
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError(this.message);
}

class PaymentUrlGenerated extends CheckoutState {
  final PaymentUrlResponseModel paymentUrlResponse;

  PaymentUrlGenerated(this.paymentUrlResponse);
}
