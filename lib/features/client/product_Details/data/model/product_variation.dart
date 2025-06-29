
class ProductVariation {
  final int id;
  final String name;
  final String price;
  final int stock;
  final AttributeValue attributeValue;
  final ColorDetail color;

  ProductVariation({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.attributeValue,
    required this.color,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'],
      attributeValue: AttributeValue.fromJson(json['attribute_value']),
      color: ColorDetail.fromJson(json['color']),
    );
  }
}

class AttributeValue {
  final int id;
  final String name;

  AttributeValue({
    required this.id,
    required this.name,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}

class ColorDetail {
  final int id;
  final String name;
  final String code;

  ColorDetail({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ColorDetail.fromJson(Map<String, dynamic> json) {
    return ColorDetail(
      id: json['id'],
      name: json['name'] ?? '',
      code: json['code'] ?? '#000000',
    );
  }
}
