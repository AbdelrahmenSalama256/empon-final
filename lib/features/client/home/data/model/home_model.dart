import 'package:equatable/equatable.dart';

class HomeModel extends Equatable {
  final bool success;
  final String message;
  final List<dynamic> ads;
  final List<Account> accounts;

  const HomeModel({
    required this.success,
    required this.message,
    required this.ads,
    required this.accounts,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      ads: json['data']['ads'] ?? [], // Changed this line
      accounts: (json['data']['accounts'] as List<dynamic>? ?? [])
          .map((item) => Account.fromJson(item))
          .toList(),
    );
  }
  @override
  List<Object?> get props => [success, message, ads, accounts];
}

class Account extends Equatable {
  final int id;
  final String name;
  final String image;
  final List<Product> products;
  final bool isActive;

  const Account( {
    required this.id,
    required this.name,
    required this.image,
    required this.products,
    required this.isActive,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item))
          .toList(),
      isActive: json['active'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, image, products, isActive];
}

class Product extends Equatable {
  final int id;
  final String name;
  final String price;
  final String imageUrl;
  final bool isFavourite;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isFavourite,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isFavourite: json['is_favourite'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, isFavourite];
}
