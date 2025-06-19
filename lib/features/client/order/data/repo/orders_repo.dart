// lib/features/client/order/data/repo/order_repo.dart
import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/features/client/order/data/model/order_details_model.dart';
import 'package:embone/features/client/order/data/model/order_model.dart';

class OrderRepo {
  final ApiConsumer api;
  static final Set<int> _canceledOrderIds = {};

  OrderRepo(this.api);

  Future<Either<String, OrderResponseModel>> fetchOrders() async {
    try {
      // final response = await api.get(EndPoints.orders);
      // final orderData = OrderResponseModel.fromJson(response.data);
      final orderData = OrderResponseModel.fromJson({
        "success": true,
        "message": "Orders fetched successfully",
        "data": [
          {
            "id": 1,
            "order_number": "1947034",
            "date": "05-12-2019",
            "quantity": 3,
            "total_price": 2500.00,
            "status": "delivered"
          },
          {
            "id": 2,
            "order_number": "1947035",
            "date": "06-12-2019",
            "quantity": 5,
            "total_price": 4500.00,
            "status": _canceledOrderIds.contains(2) ? "canceled" : "canceled"
          },
          {
            "id": 3,
            "order_number": "1947036",
            "date": "07-12-2019",
            "quantity": 2,
            "total_price": 1500.00,
            "status": _canceledOrderIds.contains(3) ? "canceled" : "in_delivery"
          },
          {
            "id": 4,
            "order_number": "1947037",
            "date": "08-12-2019",
            "quantity": 4,
            "total_price": 3200.00,
            "status": "delivered"
          }
        ]
      });

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
    _canceledOrderIds.add(orderId);

    try {
      // final response = await api.patch(
      //   "${EndPoints.cancelOrder}/$orderId",
      //   data: {'status': 'canceled'},
      // );
      // return Right(response.data['message'] ?? 'Order canceled successfully');
      final response = <String, dynamic>{
        "success": true,
        "message": "Order canceled successfully"
      };
      return Right(
          response['message'] as String? ?? 'Order canceled successfully');
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
      final orderDetailsData = {
        1: {
          "success": true,
          "message": "Order details fetched successfully",
          "data": {
            "items": [
              {
                "name": "Orlando Athletic Shoes",
                "color": "White",
                "size": "39",
                "price": 900.00,
                "image":
                    "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb"
              },
              {
                "name": "Orlando Athletic Shoes",
                "color": "Blue",
                "size": "39",
                "price": 900.00,
                "image":
                    "https://images.unsplash.com/photo-1542291026-7eec264c27ff"
              }
            ],
            "summary": {
              "subtotal": 1800.00,
              "delivery_fee": 50.00,
              "total": 1850.00
            },
            "payment_method": {"type": "cash_on_delivery"}
          }
        },
        2: {
          "success": true,
          "message": "Order details fetched successfully",
          "data": {
            "items": [
              {
                "name": "Running Shoes",
                "color": "Black",
                "size": "40",
                "price": 1200.00,
                "image":
                    "https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa"
              }
            ],
            "summary": {
              "subtotal": 1200.00,
              "delivery_fee": 50.00,
              "total": 1250.00
            },
            "payment_method": {"type": "cash_on_delivery"}
          }
        },
        3: {
          "success": true,
          "message": "Order details fetched successfully",
          "data": {
            "items": [
              {
                "name": "Sneakers",
                "color": "Red",
                "size": "38",
                "price": 800.00,
                "image":
                    "https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a"
              }
            ],
            "summary": {
              "subtotal": 800.00,
              "delivery_fee": 50.00,
              "total": 850.00
            },
            "payment_method": {"type": "cash_on_delivery"}
          }
        },
        4: {
          "success": true,
          "message": "Order details fetched successfully",
          "data": {
            "items": [
              {
                "name": "Casual Shoes",
                "color": "Grey",
                "size": "41",
                "price": 1000.00,
                "image":
                    "https://images.unsplash.com/photo-1608231387042-66d1773070a5"
              }
            ],
            "summary": {
              "subtotal": 1000.00,
              "delivery_fee": 50.00,
              "total": 1050.00
            },
            "payment_method": {"type": "cash_on_delivery"}
          }
        }
      };

      final json = orderDetailsData[orderId];
      if (json == null) {
        return Left('Order $orderId not found');
      }
      final orderDetails = OrderDetailsResponseModel.fromJson(json, orderId);
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
