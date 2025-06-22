// lib/features/client/order/data/repo/order_repo.dart
import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/order/data/model/order_details_model.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';

class OrderRepo {
  final ApiConsumer api;

  OrderRepo(this.api);

  Future<Either<String, OrderResponseModel>> fetchOrders() async {
    try {
      final response = await api.get(EndPoints.userOrders);
      final orderData = OrderResponseModel.fromJson(response.data);
      // final orderData = OrderResponseModel.fromJson({
      //   "success": true,
      //   "message": "Orders fetched successfully",
      //   "data": [
      //     {
      //       "id": 1,
      //       "order_number": "1947034",
      //       "date": "05-12-2019",
      //       "quantity": 3,
      //       "total_price": 2500.00,
      //       "status": "delivered"
      //     },
      //     {
      //       "id": 2,
      //       "order_number": "1947035",
      //       "date": "06-12-2019",
      //       "quantity": 5,
      //       "total_price": 4500.00,
      //       "status": _canceledOrderIds.contains(2) ? "canceled" : "canceled"
      //     },
      //     {
      //       "id": 3,
      //       "order_number": "1947036",
      //       "date": "07-12-2019",
      //       "quantity": 2,
      //       "total_price": 1500.00,
      //       "status": _canceledOrderIds.contains(3) ? "canceled" : "in_delivery"
      //     },
      //     {
      //       "id": 4,
      //       "order_number": "1947037",
      //       "date": "08-12-2019",
      //       "quantity": 4,
      //       "total_price": 3200.00,
      //       "status": "delivered"
      //     }
      //   ]
      // });

      return Right(orderData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch orders: $e');
    }
  }

  Future<Either<String, String>> cancelOrder(int orderId) async {
    // _canceledOrderIds.add(orderId);

    try {
      final response = await api.post(
        "${EndPoints.cancelOrder}/$orderId/cancel",
      );
      return Right(response.data['message'] ?? 'Order canceled successfully');
      // final response = <String, dynamic>{
      //   "success": true,
      //   "message": "Order canceled successfully"
      // };
      // return Right(
      //     response['message'] as String? ?? 'Order canceled successfully');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to cancel order: $e');
    }
  }

  Future<Either<String, OrderDetailsResponseModel>> fetchOrderDetails(
      int orderId) async {
    try {
      // Make the actual API call
      final response = await api.get("${EndPoints.orderDetails}/$orderId");

      // Parse the response
      final orderDetails =
          OrderDetailsResponseModel.fromJson(response.data, orderId);

      return Right(orderDetails);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch order details: $e');
    }
  }
}
