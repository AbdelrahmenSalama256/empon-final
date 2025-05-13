class CartResponseModel {
  final bool success;
  final String message;
  final List<CartItemModel> data;

  CartResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => CartItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CartItemModel {
  final int id;
  final int productId;
  final String name;
  final String image;
  final int quantity;
  final String price;
  final CartAttribute? attributes;
  final CartColor? color;

  CartItemModel(
      {required this.id,
      required this.name,
      required this.image,
      required this.quantity,
      required this.price,
      this.attributes,
      this.color,
      required this.productId});

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? '0.00',
      attributes: json['attributes'] != null
          ? CartAttribute.fromJson(json['attributes'])
          : null,
      color: json['color'] != null ? CartColor.fromJson(json['color']) : null,
    );
  }
}

class CartAttribute {
  final int id;
  final String name;
  final String attribute;

  CartAttribute({
    required this.id,
    required this.name,
    required this.attribute,
  });

  factory CartAttribute.fromJson(Map<String, dynamic> json) {
    return CartAttribute(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      attribute: json['attribute'] ?? '',
    );
  }
}

class CartColor {
  final int id;
  final String name;
  final String code;

  CartColor({
    required this.id,
    required this.name,
    required this.code,
  });

  factory CartColor.fromJson(Map<String, dynamic> json) {
    return CartColor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
    );
  }
}

class AddToCartResponseModel {
  final bool success;
  final String message;
  final CartItemModel data;

  AddToCartResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AddToCartResponseModel.fromJson(Map<String, dynamic> json) {
    return AddToCartResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: CartItemModel.fromJson(json['data']),
    );
  }
}
