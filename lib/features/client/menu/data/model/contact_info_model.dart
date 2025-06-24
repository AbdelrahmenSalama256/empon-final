class ContactInfoResponse {
  final bool success;
  final String message;
  final ContactInfo data;

  ContactInfoResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContactInfoResponse.fromJson(Map<String, dynamic> json) {
    return ContactInfoResponse(
      success: json['success'],
      message: json['message'],
      data: ContactInfo.fromJson(json['data']),
    );
  }
}

class ContactInfo {
  final int id;
  final String whatsappNumber;
  final String contactEmail;
  final String createdAt;
  final String updatedAt;

  ContactInfo({
    required this.id,
    required this.whatsappNumber,
    required this.contactEmail,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      id: json['id'],
      whatsappNumber: json['whatsapp_number'],
      contactEmail: json['contact_email'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
