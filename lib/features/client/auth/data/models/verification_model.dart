class VerificationResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  VerificationResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
        );
  }
}
