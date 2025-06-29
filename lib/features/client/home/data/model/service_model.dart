import 'dart:convert';

import 'package:flutter/foundation.dart';

// Helper function to decode the main JSON response
List<ServiceModel> serviceModelFromJson(String str) {
  try {
    final decodedJson = json.decode(str);
    if (decodedJson is Map<String, dynamic> && decodedJson["data"] != null) {
      final data = decodedJson["data"];
      if (data is List) {
        return List<ServiceModel>.from(
            data.map((x) => ServiceModel.fromJson(x)));
      }
    }
    return [];
  } catch (e) {
    if (kDebugMode) {
      print('Error decoding JSON: $e');
    }
    return []; // Return empty list on error
  }
}

class ServiceModel {
  final int? id;
  final String? name;
  final String? details;
  final String? price;
  final bool? active;
  final bool? approved;
  final String? approvalStatus;
  final ServiceCategory? category;
  final ServiceAccount? account;
  final String? logo;
  final String? mainImage;
  final List<String>? listImages;
  final String? createdAt;
  final String? updatedAt;

  ServiceModel({
    this.id,
    this.name,
    this.details,
    this.price,
    this.active,
    this.approved,
    this.approvalStatus,
    this.category,
    this.account,
    this.logo,
    this.mainImage,
    this.listImages,
    this.createdAt,
    this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"] as int?,
        name: json["name"] as String?,
        details: json["details"] as String?,
        price: json["price"] as String?,
        active: json["active"] as bool?,
        approved: json["approved"] as bool?,
        approvalStatus: json["approval_status"] as String?,
        category: json["category"] != null
            ? ServiceCategory.fromJson(json["category"] as Map<String, dynamic>)
            : null,
        account: json["account"] != null
            ? ServiceAccount.fromJson(json["account"] as Map<String, dynamic>)
            : null,
        logo: json["logo"] as String?,
        mainImage: json["main_image"] as String?,
        listImages: json["list_images"] != null
            ? List<String>.from(json["list_images"] as List<dynamic>)
            : null,
        createdAt: json["created_at"] as String?,
        updatedAt: json["updated_at"] as String?,
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
        id: json["id"] as int,
        name: json["name"] as String,
        logo: json["logo"] as String,
        cover: json["cover"] as String,
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
        id: json["id"] as int,
        name: json["name"] as String,
      );
}
