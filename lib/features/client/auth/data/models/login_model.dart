import 'package:embone/features/client/auth/data/models/user_data_model.dart';

class LoginModel {
  final bool? success;
  final String? message;
  final LoginData? data;

  LoginModel({this.success, this.message, this.data});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class LoginData {
  final User? user;
  final bool? isDeleted;
  final bool? isVerified;

  LoginData({this.user, this.isDeleted, this.isVerified});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: User.fromJson(json),
      isDeleted: json['is_deleted'] as bool?,
      isVerified: json['is_verified'] as bool? ??
          (json['phone_verified_at'] == true ||
              json['email_verified_at'] == true),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'is_deleted': isDeleted,
        'is_verified': isVerified,
      };
}
