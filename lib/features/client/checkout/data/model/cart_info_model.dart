class CartInfoModel {
  final bool success;
  final String message;
  final CartInfoData? data;

  CartInfoModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CartInfoModel.fromJson(Map<String, dynamic> json) {
    return CartInfoModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? CartInfoData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartInfoData {
  final List<CartInfoItem>? items;
  final double totalOrderPrice;

  CartInfoData({
    this.items,
    required this.totalOrderPrice,
  });

  factory CartInfoData.fromJson(Map<String, dynamic> json) {
    return CartInfoData(
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => CartInfoItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalOrderPrice: (json['total_order_price'] as num).toDouble(),
    );
  }
}

class CartInfoItem {
  final String productName;
  final int variationId;
  final int quantity;
  final String price;
  final double totalPrice;

  CartInfoItem({
    required this.productName,
    required this.variationId,
    required this.quantity,
    required this.price,
    required this.totalPrice,
  });

  factory CartInfoItem.fromJson(Map<String, dynamic> json) {
    return CartInfoItem(
      productName: json['product_name'] as String,
      variationId: json['variation_id'] as int,
      quantity: json['quantity'] as int,
      price: json['price'] as String,
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}
