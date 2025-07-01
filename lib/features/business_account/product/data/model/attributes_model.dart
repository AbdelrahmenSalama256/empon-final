class AttributesResponse {
  final bool success;
  final String message;
  final List<Attribute> data;

  AttributesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttributesResponse.fromJson(Map<String, dynamic> json) {
    return AttributesResponse(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Attribute.fromJson(item))
          .toList(),
    );
  }
}
class Attribute {
  final int id;
  final String name;
  final List<AttributeValue> values;

  Attribute({
    required this.id,
    required this.name,
    required this.values,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'],
      name: json['name'],
      values: (json['values'] as List)
          .map((v) => AttributeValue.fromJson(v))
          .toList(),
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
      id: json['id'],
      name: json['name'],
      attribute: json['attribute'],
    );
  }
}
