import 'package:embone/features/client/order/data/model/order_details_model.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';

class OrdersState {}

final class OrdersInitial extends OrdersState {}

class OrderInitial extends OrdersState {}

class OrderLoading extends OrdersState {}

class OrderLoaded extends OrdersState {
  final OrderResponseModel orderResponse;

  OrderLoaded(this.orderResponse);
}

class OrderError extends OrdersState {
  final String message;

  OrderError(this.message);
}

class OrderCanceled extends OrdersState {
  final String message;

  OrderCanceled(this.message);
}

class OrderDetailsLoading extends OrdersState {}

class OrderDetailsLoaded extends OrdersState {
  final OrderDetailsModel currentOrderDetails;

  OrderDetailsLoaded(this.currentOrderDetails);
}

class OrderDetailsError extends OrdersState {
  final String message;

  OrderDetailsError(this.message);
}
class OrderUpdateLoading extends OrdersState {}

class OrderUpdateLoaded extends OrdersState {
  

}

class OrderUpdateError extends OrdersState {
  final String message;

  OrderUpdateError(this.message);
}
