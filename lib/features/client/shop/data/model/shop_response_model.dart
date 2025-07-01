import 'package:embone/features/client/home/data/model/home_model.dart';

class ShopResponseModel {
  final bool success;
  final String message;
  final ShopData? data;

  ShopResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ShopResponseModel.fromJson(Map<String, dynamic> json) {
    return ShopResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? ShopData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class ShopData {
  final List<Ad>? ads;
  final List<CategoryModel>? categories;

  ShopData({
    this.ads,
    this.categories,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      ads: (json['ads'] as List<dynamic>? ?? [])
          .map((item) => Ad.fromJson(item))
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'ads': ads,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}

class CategoryModel {
  final CategoryDetail? category;
  final List<AccountModel>? accounts;

  CategoryModel({
    this.category,
    this.accounts,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] != null
          ? CategoryDetail.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      accounts: (json['accounts'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'category': category?.toJson(),
        'accounts': accounts?.map((e) => e.toJson()).toList(),
      };
}

class CategoryDetail {
  final int? id;
  final String? name;
  final String? imageUrl;
  final String? imageType;

  CategoryDetail({
    this.id,
    this.name,
    this.imageUrl,
    this.imageType,
  });

  factory CategoryDetail.fromJson(Map<String, dynamic> json) {
    return CategoryDetail(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageUrl: json['image_url'] as String?,
      imageType: json['image_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'image_type': imageType,
      };
}

class AccountModel {
  final int? id;
  final String? name;
  final String? image;
  final List<ProductModel>? products;

  AccountModel({
    this.id,
    this.name,
    this.image,
    this.products,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'products': products?.map((e) => e.toJson()).toList(),
      };
}

class ProductModel {
  final int? id;
  final String? name;
  final String? price;
  final String? imageUrl;
  final bool? isFavourite;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.imageUrl,
    this.isFavourite,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      imageUrl: json['image_url'] as String?,
      isFavourite: json['is_favourite'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'image_url': imageUrl,
        'is_favourite': isFavourite,
      };
}
