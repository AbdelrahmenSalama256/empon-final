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
  final String logo;
  final String mainImage;
  final List<String> listImages;
  final String createdAt;
  final String updatedAt;

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
    required this.logo,
    required this.mainImage,
    required this.listImages,
    required this.createdAt,
    required this.updatedAt,
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
      logo: json['logo'],
      mainImage: json['main_image'],
      listImages: List<String>.from(json['list_images'] ?? []),
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
    String? logo,
    String? mainImage,
    List<String>? listImages,
    String? createdAt,
    String? updatedAt,
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
      logo: logo ?? this.logo,
      mainImage: mainImage ?? this.mainImage,
      listImages: listImages ?? this.listImages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
