import 'dart:convert';

// Helper function to decode the main JSON response
List<ServiceModel> serviceModelFromJson(String str) => List<ServiceModel>.from(
    json.decode(str)["data"].map((x) => ServiceModel.fromJson(x)));

class ServiceModel {
  final int id;
  final String name;
  final String details;
  final String price;
  final bool active;
  final bool approved;
  final String approvalStatus;
  final ServiceCategory category;
  final ServiceAccount account;
  final String logo;
  final String mainImage;
  final List<String> listImages;
  final String createdAt;
  final String updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.details,
    required this.price,
    required this.active,
    required this.approved,
    required this.approvalStatus,
    required this.category,
    required this.account,
    required this.logo,
    required this.mainImage,
    required this.listImages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        name: json["name"],
        details: json["details"],
        price: json["price"],
        active: json["active"],
        approved: json["approved"],
        approvalStatus: json["approval_status"],
        category: ServiceCategory.fromJson(json["category"]),
        account: ServiceAccount.fromJson(json["account"]),
        logo: json["logo"],
        mainImage: json["main_image"],
        listImages: List<String>.from(json["list_images"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );
}

class ServiceAccount {
  final int id;
  final String name;
  final String logo;
  final String cover;
  final List<dynamic> products; // Simplified as dynamic for now

  ServiceAccount({
    required this.id,
    required this.name,
    required this.logo,
    required this.cover,
    required this.products,
  });

  factory ServiceAccount.fromJson(Map<String, dynamic> json) => ServiceAccount(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        cover: json["cover"],
        products: json["products"] ?? [],
      );
}

class ServiceCategory {
  final int id;
  final String name;

  ServiceCategory({
    required this.id,
    required this.name,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) =>
      ServiceCategory(
        id: json["id"],
        name: json["name"],
      );
}
