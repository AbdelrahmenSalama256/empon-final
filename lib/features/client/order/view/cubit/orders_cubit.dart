import 'package:bloc/bloc.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/services/service_locator.dart';
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
  List<OrderModel> pendingOrders = [];
  List<OrderModel> all = [];
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
            .where((order) =>
                order.status == 'in_delivery' || order.status == 'pending')
            .toList(); // Include pending orders
        canceledOrders = orderResponse.data
            .where((order) => order.status == 'cancelled')
            .toList();
        PrintUtil.debug('Delivered orders: $deliveredOrders');
        PrintUtil.debug('In delivery orders: $inDeliveryOrders');
        PrintUtil.debug('Canceled orders: $canceledOrders');
        emit(OrderLoaded(orderResponse));
      },
    );
  }
    Future<void> fetchAccountOrders() async {
    emit(OrderLoading());

    final result = await orderRepo.fetchAccountOrders(sl<GlobalCubit>().businessId!);
    result.fold(
      (error) => emit(OrderError(error)),
      (orderResponse) {
        deliveredOrders = orderResponse.data
            .where((order) => order.status == 'delivered')
            .toList();
        inDeliveryOrders = orderResponse.data
            .where((order) =>
                order.status == 'in_delivery' || order.status == 'pending')
            .toList(); // Include pending orders
        canceledOrders = orderResponse.data
            .where((order) => order.status == 'cancelled')
            .toList();
        all =orderResponse.data;
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
        // Check pendingOrders first
        final pendingIndex =
            pendingOrders.indexWhere((order) => order.id == orderId);
        if (pendingIndex != -1) {
          canceledOrder = OrderModel(
            id: pendingOrders[pendingIndex].id,
            orderNumber: pendingOrders[pendingIndex].orderNumber,
            date: pendingOrders[pendingIndex].date,
            quantity: pendingOrders[pendingIndex].quantity,
            totalPrice: pendingOrders[pendingIndex].totalPrice,
            status: 'cancelled',
          );
          pendingOrders.removeAt(pendingIndex);
        } else {
          // Check inDeliveryOrders
          final inDeliveryIndex =
              inDeliveryOrders.indexWhere((order) => order.id == orderId);
          if (inDeliveryIndex != -1) {
            canceledOrder = OrderModel(
              id: inDeliveryOrders[inDeliveryIndex].id,
              orderNumber: inDeliveryOrders[inDeliveryIndex].orderNumber,
              date: inDeliveryOrders[inDeliveryIndex].date,
              quantity: inDeliveryOrders[inDeliveryIndex].quantity,
              totalPrice: inDeliveryOrders[inDeliveryIndex].totalPrice,
              status: 'cancelled',
            );
            inDeliveryOrders.removeAt(inDeliveryIndex);
          } else {
            // Check deliveredOrders
            final deliveredIndex =
                deliveredOrders.indexWhere((order) => order.id == orderId);
            if (deliveredIndex != -1) {
              canceledOrder = OrderModel(
                id: deliveredOrders[deliveredIndex].id,
                orderNumber: deliveredOrders[deliveredIndex].orderNumber,
                date: deliveredOrders[deliveredIndex].date,
                quantity: deliveredOrders[deliveredIndex].quantity,
                totalPrice: deliveredOrders[deliveredIndex].totalPrice,
                status: 'cancelled',
              );
              deliveredOrders.removeAt(deliveredIndex);
            }
          }
        }

        // Only add to canceledOrders if the order was found and not already canceled
        if (canceledOrder != null &&
            !canceledOrders.any((order) => order.id == canceledOrder!.id)) {
          canceledOrders.add(canceledOrder);
        }

        PrintUtil.debug('Delivered orders: $deliveredOrders');
        PrintUtil.debug('In delivery orders: $inDeliveryOrders');
        PrintUtil.debug('Canceled orders: $canceledOrders');
        PrintUtil.debug('Pending orders: $pendingOrders');
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
      case 'cancelled':
        return canceledOrders;
      case 'pending':
        return pendingOrders;
      case 'all':
        return all;
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
    Future<void> updateOrederStatus(int orderId,String status ) async {
    emit(OrderUpdateLoading());
    final result = await orderRepo.updateOrderStatus(orderId, status);
    result.fold(
      (error) => emit(OrderUpdateError(error)),
      (response) {
        emit(OrderUpdateLoaded());
      },
    );
  }
}
