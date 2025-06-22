class ServiceCategoryModel {
  final bool success;
  final String message;
  final List<ServiceCategoryData> data;

  ServiceCategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      success: json['success'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => ServiceCategoryData.fromJson(e))
          .toList(),
    );
  }
}

class ServiceCategoryData {
  final int id;
  final String name;
  final String slug;
  final String createdAt;
  final String updatedAt;

  ServiceCategoryData({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceCategoryData.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryData(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
