class StoreRequestResponse {
  final bool? success;
  final String? message;
  final StoreRequestData? data;

  StoreRequestResponse({
    this.success,
     this.message,
     this.data,
  });

  factory StoreRequestResponse.fromJson(Map<String, dynamic> json) {
    return StoreRequestResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? StoreRequestData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StoreRequestData {
  final int id;
  final String accountId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoreRequestData({
    required this.id,
    required this.accountId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StoreRequestData.fromJson(Map<String, dynamic> json) {
    return StoreRequestData(
      id: json['id'],
      accountId: json['account_id'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
