class AccountResponseModel {
  final bool success;
  final String message;
  final Account data;

  AccountResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AccountResponseModel.fromJson(Map<String, dynamic> json) {
    return AccountResponseModel(
      success: json['success'],
      message: json['message'],
      data: Account.fromJson(json['data']),
    );
  }
}

class Account {
  final int id;
  final String name;
  final String description;
  final String email;
  final String phone;
  final String? videoUrl;
  final String? website;
  final String city;
  final String state;
  final String country;
  final String address;
  final double lng;
  final double lat;
  final String postalCode;
  final String type;
  final bool verified;
  final bool status;
  final String logo;
  final String cover;
  final int totalProducts;
  final List<Product> products;
  final int totalServices;
  final List<Service> services;
  final int totalFollowers;
  final List<dynamic> followers;

  Account({
    required this.id,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    this.videoUrl,
    this.website,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    required this.lng,
    required this.lat,
    required this.postalCode,
    required this.type,
    required this.verified,
    required this.status,
    required this.logo,
    required this.cover,
    required this.totalProducts,
    required this.products,
    required this.totalServices,
    required this.services,
    required this.totalFollowers,
    required this.followers,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      email: json['email'],
      phone: json['phone'],
      videoUrl: json['video_url'],
      website: json['website'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      address: json['address'],
      lng: double.parse(json['lng'].toString()),
      lat: double.parse(json['lat'].toString()),
      postalCode: json['postal_code'],
      type: json['type'],
      verified: json['verified'],
      status: json['status'],
      logo: json['logo'],
      cover: json['cover'],
      totalProducts: json['total_products'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      totalServices: json['total_services'],
      services: (json['services'] as List)
          .map((item) => Service.fromJson(item))
          .toList(),
      totalFollowers: json['total_followers'],
      followers: json['followers'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final dynamic status;
  final int active;
  final String description;
  final String image;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.status,
    required this.active,
    required this.description,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      status: json['status'],
      active: json['active'],
      description: json['description'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class Service {
  final int id;
  final String name;
  final String price;
  final String details;
  final bool active;
  final bool approved;
  final String logo;
  final String mainImage;
  final String createdAt;
  final String updatedAt;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.details,
    required this.active,
    required this.approved,
    required this.logo,
    required this.mainImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      details: json['details'],
      active: json['active'],
      approved: json['approved'],
      logo: json['logo'] ?? '',
      mainImage: json['main_image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
