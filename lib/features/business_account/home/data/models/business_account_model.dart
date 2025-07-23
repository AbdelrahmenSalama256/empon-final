class BusinessAccountResponse {
  final bool success;
  final String message;
  final BusinessAccount data;

  BusinessAccountResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessAccountResponse.fromJson(Map<String, dynamic> json) {
    return BusinessAccountResponse(
      success: json['success'],
      message: json['message'],
      data: BusinessAccount.fromJson(json['data']),
    );
  }
}

class BusinessAccount {
  final int id;
  final String? name;
  final String? description;
  final String? email;
  final String? phone;
  final String? videoUrl;
  final String? website;
  final String? city;
  final String? state;
  final String? country;
  final String? address;
  final String? lng;
  final String? lat;
  final String? postalCode;
  final int? isStore;
  final String? type;
  final bool? verified;
  final bool? isFavourited;
  final bool? isFollowed;
  final bool? isLiked;
  final int? totalFav;
  final bool? status;
  final String? logo;
  final String? cover;
  final int? totalProducts;
  final List<Product>? products;
  final int? totalServices;
  final List<Service>? services;
  final int? totalFollowers;
  final List<Follower>? followers; 
  final String? verificationRequest;

  BusinessAccount({
    required this.id,
    required this.name,
    required this.description,
    required this.email,
    required this.phone,
    required this.videoUrl,
    required this.website,
    this.isStore,
    this.totalFav,
    this.isFavourited,
    this.isFollowed,
    this.isLiked,
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
    this.followers, // Nullable list of followers
    this.verificationRequest,
  });

  factory BusinessAccount.fromJson(Map<String, dynamic> json) {
    return BusinessAccount(
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
      isStore: json['is_store'] as int?,
      address: json['address'],
      lng: json['lng'],
      lat: json['lat'],
      postalCode: json['postal_code'],
      type: json['type'],
      verified: json['verified'],
      isFavourited: json['is_favourited'] as bool?,
      isFollowed: json['is_followed'] as bool?,
      isLiked: json['is_liked'] as bool?,
      status: json['status'],
      totalFav: json['total_favourites'] as int?,
      logo: json['logo'],
      cover: json['cover'],
      totalProducts: json['total_products'],
      products:
          (json['products'] as List).map((e) => Product.fromJson(e)).toList(),
      totalServices: json['total_services'],
      services:
          (json['services'] as List).map((e) => Service.fromJson(e)).toList(),
      totalFollowers: json['total_followers'],
      followers: (json['followers'] as List?)
          ?.map((e) => Follower.fromJson(e))
          .toList(), // Parse followers
      verificationRequest: json['verification_request_response'],
    );
  }
}

class Follower {
  final int id;
  final User user;
  final String createdAt;

  Follower({
    required this.id,
    required this.user,
    required this.createdAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['id'],
      user: User.fromJson(json['user']),
      createdAt: json['created_at'],
    );
  }
}

class User {
  final int id;
  final String name;
  final String? image;

  User({
    required this.id,
    required this.name,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String price;
  final String? status;
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
      price: json['price'],
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
      price: json['price'],
      details: json['details'],
      active: json['active'],
      approved: json['approved'],
      logo: json['logo'],
      mainImage: json['main_image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
