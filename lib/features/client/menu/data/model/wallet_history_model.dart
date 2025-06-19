class WalletHistoryResponseModel {
  final bool success;
  final String message;
  final List<WalletTransactionModel> data;

  WalletHistoryResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletHistoryResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => WalletTransactionModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class WalletTransactionModel {
  final String amount;
  final String type;
  final String createdAt;

  WalletTransactionModel({
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      amount: json['amount'] ?? '0.00',
      type: json['type'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
