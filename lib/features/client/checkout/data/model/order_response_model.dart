class OrderResponseModel {
  final bool success;
  final String message;
  final OrderData? data;

  const OrderResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final int userId;
  final String grandTotal;
  final String updatedAt;
  final String createdAt;
  final int id;

  const OrderData({
    required this.userId,
    required this.grandTotal,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      userId: json['user_id'] as int,
      grandTotal: double.parse(json['grand_total'].toString()).toString(),
      updatedAt: json['updated_at'] as String,
      createdAt: json['created_at'] as String,
      id: json['id'] as int,
    );
  }
}
