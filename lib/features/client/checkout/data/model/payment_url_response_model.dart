class PaymentUrlResponseModel {
  final bool success;
  final String message;
  final String data;

  PaymentUrlResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentUrlResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
    };
  }
}
