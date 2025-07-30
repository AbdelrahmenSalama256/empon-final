import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';

import '../model/order_response_model.dart';
import '../model/payment_url_response_model.dart';

class CheckoutRepo {
  final ApiConsumer api;

  CheckoutRepo(this.api);

  Future<Either<String, OrderResponseModel>> createOrderInfo(
      int addressId) async {
    try {
      final response = await api.post(
        EndPoints.orders,
        data: {
          'address_id': addressId,
        },
      );
      final orderData = OrderResponseModel.fromJson(response.data);
      return Right(orderData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch order info: $e');
    }
  }
    Future<Either<String, OrderResponseModel>> createCachOrder(
      int orderId) async {
    try {
      final response = await api.post(
        EndPoints.cachOrders,
        data: {
          'combined_order_id': orderId,
          'payment_method': 'cash',
        },
      );
      final orderData = OrderResponseModel.fromJson(response.data);
      return Right(orderData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch order info: $e');
    }
  }

  Future<Either<String, PaymentUrlResponseModel>> generatePaymentUrl(
      double amount) async {
    try {
      final response = await api.post(
        EndPoints.topUp,
        data: {
          'amount': amount,
        },
      );
      final paymentUrlData = PaymentUrlResponseModel.fromJson(response.data);
      return Right(paymentUrlData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to generate payment URL: $e');
    }
  }
}
