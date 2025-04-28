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

  LoginData({this.user, this.isDeleted});

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      isDeleted: json['is_deleted'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'is_deleted': isDeleted,
      };
}
