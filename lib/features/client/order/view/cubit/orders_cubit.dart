import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/order/data/model/order_details_model.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepo orderRepo;
  OrdersCubit(this.orderRepo) : super(OrdersInitial());
  List<OrderModel> deliveredOrders = [];
  List<OrderModel> inDeliveryOrders = [];
  List<OrderModel> canceledOrders = [];
  OrderDetailsModel? currentOrderDetails;

  Future<void> fetchOrders() async {
    emit(OrderLoading());
    final result = await orderRepo.fetchOrders();
    result.fold(
      (error) => emit(OrderError(error)),
      (orderResponse) {
        deliveredOrders = orderResponse.data
            .where((order) => order.status == 'delivered')
            .toList();
        inDeliveryOrders = orderResponse.data
            .where((order) => order.status == 'in_delivery')
            .toList();
        canceledOrders = orderResponse.data
            .where((order) => order.status == 'canceled')
            .toList();
        PrintUtil.debug('Delivered orders: $deliveredOrders');
        PrintUtil.debug('In delivery orders: $inDeliveryOrders');
        PrintUtil.debug('Canceled orders: $canceledOrders');
        emit(OrderLoaded(orderResponse));
      },
    );
  }

  Future<void> cancelOrder(int orderId) async {
    emit(OrderLoading());
    final result = await orderRepo.cancelOrder(orderId);
    result.fold(
      (error) => emit(OrderError(error)),
      (message) {
        OrderModel? canceledOrder;
        final inDeliveryIndex =
            inDeliveryOrders.indexWhere((order) => order.id == orderId);
        if (inDeliveryIndex != -1) {
          canceledOrder = OrderModel(
            id: inDeliveryOrders[inDeliveryIndex].id,
            orderNumber: inDeliveryOrders[inDeliveryIndex].orderNumber,
            date: inDeliveryOrders[inDeliveryIndex].date,
            quantity: inDeliveryOrders[inDeliveryIndex].quantity,
            totalPrice: inDeliveryOrders[inDeliveryIndex].totalPrice,
            status: 'canceled',
          );
          inDeliveryOrders.removeAt(inDeliveryIndex);
        } else {
          final deliveredIndex =
              deliveredOrders.indexWhere((order) => order.id == orderId);
          if (deliveredIndex != -1) {
            canceledOrder = OrderModel(
              id: deliveredOrders[deliveredIndex].id,
              orderNumber: deliveredOrders[deliveredIndex].orderNumber,
              date: deliveredOrders[deliveredIndex].date,
              quantity: deliveredOrders[deliveredIndex].quantity,
              totalPrice: deliveredOrders[deliveredIndex].totalPrice,
              status: 'canceled',
            );
            deliveredOrders.removeAt(deliveredIndex);
          }
        }
        if (canceledOrder != null &&
            !canceledOrders.any((order) => order.id == canceledOrder!.id)) {
          canceledOrders.add(canceledOrder);
        }
        PrintUtil.debug('Delivered orders: $deliveredOrders');
        PrintUtil.debug('In delivery orders: $inDeliveryOrders');
        PrintUtil.debug('Canceled orders: $canceledOrders');
        emit(OrderCanceled(message));
      },
    );
  }

  List<OrderModel> getOrdersByStatus(String status) {
    switch (status) {
      case 'delivered':
        return deliveredOrders;
      case 'in_delivery':
        return inDeliveryOrders;
      case 'canceled':
        return canceledOrders;
      default:
        return [];
    }
  }

  Future<void> fetchOrderDetails(int orderId) async {
    emit(OrderDetailsLoading());
    final result = await orderRepo.fetchOrderDetails(orderId);
    result.fold(
      (error) => emit(OrderDetailsError(error)),
      (response) {
        currentOrderDetails = response.data;
        PrintUtil.debug('Order details fetched: $currentOrderDetails');
        emit(OrderDetailsLoaded(currentOrderDetails!));
      },
    );
  }
}
