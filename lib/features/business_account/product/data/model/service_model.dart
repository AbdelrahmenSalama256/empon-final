class ServiceModel {
  final bool success;
  final String message;
  final ServiceData? data;

  ServiceModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? ServiceData.fromJson(json['data']) : null,
    );
  }
}

class ServiceData {
  final int id;
  final String name;
  final String details;
  final String price;
  final bool active;
  final bool approved;
  final bool isLiked;
  final int? likes;
  final String approvalStatus;
  final String mainImage;
  final List<String> listImages;
  final String createdAt;
  final String updatedAt;
  final List<String> features;

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
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['id'],
      name: json['name'],
      details: json['details'],
      price: json['price'],
      active: json['active'],
      approved: json['approved'],
      isLiked: json['is_liked'] ?? false,
      likes: json['likes'],
      approvalStatus: json['approval_status'],
      mainImage: json['main_image'],
      listImages: List<String>.from(json['list_images'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
    );
  }
}


class ServicesResponse {
  final bool success;
  final String message;
  final List<Service> data;

  ServicesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServicesResponse.fromJson(Map<String, dynamic> json) {
    return ServicesResponse(
      success: json['success'],
      message: json['message'],
      data: List<Service>.from(json['data'].map((x) => Service.fromJson(x))),
    );
  }
}

class Service {
  final int id;
  final String name;
  final String details;
  final String price;
  final bool active;
  final bool approved;
  final String approvalStatus;
  final Category category;
  final String logo;
  final String mainImage;
  final List<String> listImages;
  final String createdAt;
  final String updatedAt;
  final int likes;

  Service({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    required this.active,
    required this.approved,
    required this.approvalStatus,
    required this.category,
    required this.logo,
    required this.mainImage,
    required this.listImages,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
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
      category: Category.fromJson(json['category']),
      logo: json['logo'],
      mainImage: json['main_image'],
      listImages: List<String>.from(json['list_images']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      likes: json['likes'],
    );
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
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
}
