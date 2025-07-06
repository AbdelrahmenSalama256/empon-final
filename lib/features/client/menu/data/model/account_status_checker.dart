class AccountStatusChecker {
  final bool success;
  final String? message;
  final Account data;

  AccountStatusChecker({
    required this.success,
    this.message,
    required this.data,
  });

  factory AccountStatusChecker.fromJson(Map<String, dynamic> json) {
    return AccountStatusChecker(
      success: json['success'],
      message: json['message'],
      data: Account.fromJson(json['data']),
    );
  }
}

class Account {
  final bool? isCompleted;
  final bool? status;

  final bool? isVerified;

  Account({
    this.isCompleted,
    this.isVerified,
    this.status,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      isCompleted: json['is_completed'] as bool?,
      status: json['status'] as bool?,
      isVerified: json['verified'] as bool?,
    );
  }
}
