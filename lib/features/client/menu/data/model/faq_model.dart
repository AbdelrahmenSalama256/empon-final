class FaqModel {
  final int id;
  final String question;
  final String answer;
  final String category;
  final int order;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic translations;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.translations,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as int,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
      order: json['order'] as int,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      translations: json['translations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'translations': translations,
    };
  }
}

// Response model to handle the API response structure
class FaqResponseModel {
  final bool success;
  final String message;
  final List<FaqModel> data;

  FaqResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FaqResponseModel.fromJson(Map<String, dynamic> json) {
    return FaqResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
