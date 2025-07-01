class HomeModel {
  final bool success;
  final String message;
  final List<Ad> ads;
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
      ads: (json['data']['ads'] as List<dynamic>? ?? [])
          .map((item) => Ad.fromJson(item))
          .toList(),
      accounts: (json['data']['accounts'] as List<dynamic>? ?? [])
          .map((item) => Account.fromJson(item))
          .toList(),
    );
  }
}

class Ad {
  final int id;
  final String name;
  final String image;
  final List<Product> products;

  const Ad({
    required this.id,
    required this.name,
    required this.image,
    required this.products,
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }
}

class Account {
  final int id;
  final String name;
  final String image;
  final List<Product> products;
  final bool isActive;

  const Account({
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
}

class Product {
  final int id;
  final String name;
  final String price;
  final String imageUrl;
  final bool isFavourite;
  final AdInfo? adInfo; // Nullable AdInfo

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.isFavourite,
    this.adInfo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: json['price'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isFavourite: json['is_favourite'] ?? false,
      adInfo: json['ad_info'] != null ? AdInfo.fromJson(json['ad_info']) : null,
    );
  }
}

class AdInfo {
  final int id;
  final String title;
  final String description;
  final String startDate;
  final String endDate;

  const AdInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  factory AdInfo.fromJson(Map<String, dynamic> json) {
    return AdInfo(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
    );
  }
}
