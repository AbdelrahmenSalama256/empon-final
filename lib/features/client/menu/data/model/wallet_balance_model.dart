class WalletBalanceResponseModel {
  final bool success;
  final String message;
  final WalletBalanceData data;

  WalletBalanceResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory WalletBalanceResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: WalletBalanceData.fromJson(json['data'] ?? {}),
    );
  }
}

class WalletBalanceData {
  final String balance;

  WalletBalanceData({
    required this.balance,
  });

  factory WalletBalanceData.fromJson(Map<String, dynamic> json) {
    return WalletBalanceData(
      balance: json['balance']?.toString() ?? '0.00',
    );
  }
}
