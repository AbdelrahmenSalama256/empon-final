// lib/features/client/order/data/repo/order_repo.dart
import 'dart:developer';

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
      return Right(orderData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch orders: $e');
    }
  }

    Future<Either<String, String>> updateOrderStatus( int orderId,String status) async {

    try {
      final response = await api.post(
        EndPoints.accountStatusOreder,
        data: {
          'order_id': orderId,
          'status': status,
        },
        isFormData: true
      );
      return Right("ghg");
    } on ServerException catch (e) {
      log(e.toString());
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      log(e.toString());
      return Left(e.errorModel.detail);
    } catch (e) {
      log(e.toString());
      return Left('Failed to fetch orders: $e');
    }
  }
    Future<Either<String, OrderResponseModel>> fetchAccountOrders(int id) async {
    try {
      final response = await api.get("${EndPoints.accountOreder}$id");
      final orderData = OrderResponseModel.fromJson(response.data);
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
