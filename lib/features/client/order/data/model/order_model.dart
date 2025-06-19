import 'package:equatable/equatable.dart';

class OrderResponseModel {
  final bool success;
  final String message;
  final List<OrderModel> data;

  OrderResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => OrderModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderModel extends Equatable {
  final int id;
  final String orderNumber;
  final String date;
  final int quantity;
  final double totalPrice;
  final String status;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.quantity,
    required this.totalPrice,
    required this.status,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      date: json['date'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'date': date,
      'quantity': quantity,
      'total_price': totalPrice,
      'status': status,
    };
  }

  @override
  List<Object?> get props =>
      [id, orderNumber, date, quantity, totalPrice, status];
}
