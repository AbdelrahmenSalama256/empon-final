class RelatedProductsModel {
  final bool success;
  final String message;
  final List<Product> products;

  const RelatedProductsModel({
    required this.success,
    required this.message,
    required this.products,
  });

  factory RelatedProductsModel.fromJson(Map<String, dynamic> json) {
    return RelatedProductsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final String code;
  final String price;
  final String image;
  final List<dynamic> images;
  final bool isLiked;
  final int likes;
  final List<Variation> variations;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.code,
    required this.price,
    required this.image,
    required this.images,
    required this.isLiked,
    required this.likes,
    required this.variations,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      price: json['price'] ?? '0',
      image: json['image'] ?? '',
      images: json['images'] ?? [],
      isLiked: json['is_liked'] ?? false,
      likes: json['likes'] ?? 0,
      variations: (json['variations'] as List<dynamic>? ?? [])
          .map((v) => Variation.fromJson(v))
          .toList(),
    );
  }
}

class Variation {
  final String name;
  final int stock;
  final String price;
  final AttributeValue attributeValue;
  final ProductColor color;

  Variation({
    required this.name,
    required this.stock,
    required this.price,
    required this.attributeValue,
    required this.color,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      name: json['name'] ?? '',
      stock: json['stock'] ?? 0,
      price: json['price'] ?? '0',
      attributeValue: AttributeValue.fromJson(json['attribute_value'] ?? {}),
      color: ProductColor.fromJson(json['color'] ?? {}),
    );
  }
}

class AttributeValue {
  final int id;
  final String name;
  final String attribute;

  AttributeValue({
    required this.id,
    required this.name,
    required this.attribute,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      attribute: json['attribute'] ?? '',
    );
  }
}

class ProductColor {
  final int id;
  final String? name;
  final String code;

  ProductColor({
    required this.id,
    this.name,
    required this.code,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      id: json['id'] ?? 0,
      name: json['name'],
      code: json['code'] ?? '#000000',
    );
  }
}
