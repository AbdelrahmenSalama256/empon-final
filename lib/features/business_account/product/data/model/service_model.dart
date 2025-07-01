class ServiceModel {
  final bool? success;
  final String? message;
  final ServiceData? data;

  ServiceModel({
    this.success,
    this.message,
    this.data,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ServiceData.fromJson(json['data']) : null,
    );
  }

  ServiceModel copyWith({
    bool? success,
    String? message,
    ServiceData? data,
  }) {
    return ServiceModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class ServiceData {
  final int? id;
  final String? name;
  final String? details;
  final String? price;
  final bool? active;
  final bool? approved;
  final bool? isLiked;
  final int? likes;
  final String approvalStatus;
  final String mainImage;
  final List<String> listImages;
  final String createdAt;
  final String updatedAt;
  final List<String> features;
  final List<Category> categoties;

  ServiceData({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    required this.active,
    required this.approved,
    required this.isLiked,
    required this.likes,
    required this.approvalStatus,
    required this.mainImage,
    required this.listImages,
    required this.createdAt,
    required this.updatedAt,
    required this.features,
    required this.categoties
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    // Convert features object to Map<String, String>
    return ServiceData(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      price: json['price'],
      active: json['active'],
      approved: json['approved'],
      isLiked: json['is_liked'],
      likes: json['likes'],
      approvalStatus: json['approval_status'],
      mainImage: json['main_image'],
      listImages: json['list_images'] != null
          ? List<String>.from(json['list_images'])
          : <String>[],
      features: json['features'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      categoties: json['category'] is List
          ? (json['category'] as List)
              .map((item) => Category.fromJson(item))
              .toList()
          : json['category'] is Map
              ? [Category.fromJson(json['category'])]
              : [],
    );
  }

  ServiceData copyWith({
    int? id,
    String? name,
    String? details,
    String? price,
    bool? active,
    bool? approved,
    bool? isLiked,
    int? likes,
    String? approvalStatus,
    String? mainImage,
    List<String>? listImages,
    String? createdAt,
    String? updatedAt,
    List<String>? features,
    List<Category>? categories
  }) {
    return ServiceData(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      price: price ?? this.price,
      active: active ?? this.active,
      approved: approved ?? this.approved,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      mainImage: mainImage ?? this.mainImage,
      listImages: listImages ?? this.listImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      features: features??this.features,
      categoties: categories??categoties,
    );
  }
}

class ServicesResponse {
  final bool? success;
  final String? message;
  final List<Service>? data;

  ServicesResponse({
    this.success,
    this.message,
    this.data,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? List<Service>.from(json['data'].map((x) => Service.fromJson(x)))
          : null,
    );
  }

  ServicesResponse copyWith({
    bool? success,
    String? message,
    List<Service>? data,
  }) {
    return ServicesResponse(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}

class Service {
  final int? id;
  final String? name;
  final String? details;
  final String? price;
  final bool? active;
  final bool? approved;
  final String? approvalStatus;
  final Category? category;
  final String? logo;
  final String? mainImage;
  final List<String>? listImages;
  final String? createdAt;
  final String? updatedAt;
  final int? likes;

  Service({
    this.id,
    this.name,
    this.details,
    this.price,
    this.active,
    this.approved,
    this.approvalStatus,
    this.category,
    this.logo,
    this.mainImage,
    this.listImages,
    this.createdAt,
    this.updatedAt,
    this.likes,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      price: json['price'],
      active: json['active'],
      approved: json['approved'],
      approvalStatus: json['approval_status'],
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      logo: json['logo'],
      mainImage: json['main_image'],
      listImages: json['list_images'] != null
          ? List<String>.from(json['list_images'])
          : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      likes: json['likes'],
    );
  }

  Service copyWith({
    int? id,
    String? name,
    String? details,
    String? price,
    bool? active,
    bool? approved,
    String? approvalStatus,
    Category? category,
    String? logo,
    String? mainImage,
    List<String>? listImages,
    String? createdAt,
    String? updatedAt,
    int? likes,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      price: price ?? this.price,
      active: active ?? this.active,
      approved: approved ?? this.approved,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      category: category ?? this.category,
      logo: logo ?? this.logo,
      mainImage: mainImage ?? this.mainImage,
      listImages: listImages ?? this.listImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
    );
  }
}

class Category {
  final int? id;
  final String? name;
  final String? slug;
  final String? createdAt;
  final String? updatedAt;

  Category({
    this.id,
    this.name,
    this.slug,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? slug,
    String? createdAt,
    String? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
