// models/category_model.dart

class Category {
  final int id;
  final String name;
  final String description;
  final String icon;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
      );
}
class CategoryResponse {
  final bool success;
  final String message;
  final List<Category> data;

  CategoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        success: json['success'],
        message: json['message'],
        data: List<Category>.from(
          json['data'].map((item) => Category.fromJson(item)),
        ),
      );
}
