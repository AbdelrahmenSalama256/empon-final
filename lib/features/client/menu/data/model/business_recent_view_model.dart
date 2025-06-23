class BusinessModel {
  final int id;
  final String name;
  final String imageUrl;
  final String type;

  BusinessModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String? ?? '', // Handle null image_url
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'type': type,
    };
  }
}

class BusinessResponseModel {
  final bool success;
  final String message;
  final List<BusinessModel> data;

  BusinessResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BusinessResponseModel.fromJson(Map<String, dynamic> json) {
    return BusinessResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => BusinessModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
