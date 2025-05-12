class AccountResponse {
  final bool success;
  final String message;
  final AccountModel? data;

  AccountResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AccountResponse.fromJson(Map<String, dynamic> json) {
    return AccountResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AccountModel.fromJson(json['data']) : null,
    );
  }
}

class AccountModel {
  final String name;
  final String description;
  final String videoUrl;
  final String website;
  final String email;
  final String phone;
  final String cityId;
  final String address;
  final String postalCode;
  final String lat;
  final String lng;
  final int userId;
  final String type;
  final String updatedAt;
  final String createdAt;
  final int id;

  AccountModel({
    required this.name,
    required this.description,
    required this.videoUrl,
    required this.website,
    required this.email,
    required this.phone,
    required this.cityId,
    required this.address,
    required this.postalCode,
    required this.lat,
    required this.lng,
    required this.userId,
    required this.type,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['video_url'] ?? '',
      website: json['website'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cityId: json['city_id'] ?? '',
      address: json['address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      lat: json['lat'] ?? '',
      lng: json['lng'] ?? '',
      userId: json['user_id'] ?? 0,
      type: json['type'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}
