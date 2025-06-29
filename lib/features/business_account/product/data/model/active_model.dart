class ActiveResponseModel {
  final bool success;
  final String message;

  ActiveResponseModel({
    required this.success,
    required this.message,
  });

  factory ActiveResponseModel.fromJson(Map<String, dynamic> json) {
    return ActiveResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
