import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final bool success;
  final String message;
  final List<SearchProduct> products;

  const SearchModel({
    required this.success,
    required this.message,
    required this.products,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      products: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SearchProduct.fromJson(item))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [success, message, products];
}

class SearchProduct extends Equatable {
  final int id;
  final String name;
  final String description;
  final String price;
  final String image;

  const SearchProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory SearchProduct.fromJson(Map<String, dynamic> json) {
    return SearchProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      image: json['image'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, description, price, image];
}
