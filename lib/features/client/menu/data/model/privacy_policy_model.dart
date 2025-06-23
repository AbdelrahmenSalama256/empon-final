class PrivacyPolicyResponse {
  final bool success;
  final String message;
  final PrivacyPolicy data;

  PrivacyPolicyResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PrivacyPolicyResponse.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicyResponse(
      success: json['success'],
      message: json['message'],
      data: PrivacyPolicy.fromJson(json['data']),
    );
  }
}

class PrivacyPolicy {
  final int id;
  final String content;
  final String lastUpdated;

  PrivacyPolicy({
    required this.id,
    required this.content,
    required this.lastUpdated,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      id: json['id'],
      content: json['content'],
      lastUpdated: json['last_updated'],
    );
  }
}
