class OrderDetailsResponseModel {
  final bool success;
  final String message;
  final OrderDetailsModel data;

  const OrderDetailsResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory OrderDetailsResponseModel.fromJson(
      Map<String, dynamic> json, int orderId) {
    return OrderDetailsResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: OrderDetailsModel.fromJson(json['data'], orderId),
    );
  }
}

class OrderDetailsModel {
  final int orderId;
  final List<OrderItemModel> items;
  final OrderSummaryModel summary;
  final PaymentMethodModel paymentMethod;

  const OrderDetailsModel({
    required this.orderId,
    required this.items,
    required this.summary,
    required this.paymentMethod,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json, int orderId) {
    return OrderDetailsModel(
      orderId: orderId,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item))
          .toList(),
      summary: OrderSummaryModel.fromJson(json['summary']),
      paymentMethod: PaymentMethodModel.fromJson(json['payment_method']),
    );
  }
}

class OrderItemModel {
  final String name;
  final String color;
  final String size;
  final double price;
  final String image;

  const OrderItemModel({
    required this.name,
    required this.color,
    required this.size,
    required this.price,
    required this.image,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name'] as String,
      color: json['color'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }
}

class OrderSummaryModel {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const OrderSummaryModel({
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['delivery_fee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

class PaymentMethodModel {
  final String type;

  const PaymentMethodModel({required this.type});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(type: json['type'] as String);
  }
}
