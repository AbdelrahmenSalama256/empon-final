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
      approvalStatus: json['approval_status'],
      logo: json['logo'],
      mainImage: json['main_image'],
      listImages: List<String>.from(json['list_images'] ?? []),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
