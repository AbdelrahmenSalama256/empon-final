import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/notification/notification_handler.dart';
import 'package:embone/features/client/auth/data/models/login_model.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterRepo {
  final ApiConsumer api;

  RegisterRepo(this.api);

  Future<Either<String, String>> registerUser({
    required String firstName,
    required String lastName,
    required String birthDate,
    required String gender,
    required String phone,
    required String email,
    String? anotherEmail,
    required String password,
    required String passwordConfirmation,
    required String countryId,
    required String cityId,
    required String stateId,
    required String lat,
    required String lng,
    required String address,
    XFile? image,
  }) async {
    try {
      // Fetch FCM token
      final fcmToken = await NotificationHandler.getToken();

      // Prepare the form data
      Map<String, dynamic> data = {
        "first_name": firstName,
        "last_name": lastName,
        "birth_date": birthDate,
        "gender": gender,
        "phone": phone,
        "email": email,
        if (anotherEmail != null) "another_email": anotherEmail,
        "password": password,
        "password_confirmation": passwordConfirmation,
        "fcm_token": fcmToken,
        "country_id": countryId,
        "city_id": cityId,
        "state_id": stateId,
        "lat": lat,
        "lng": lng,
        "address": address,
      };

      if (image != null) {
        data['image'] = await uploadImageToAPI(image);
      }

      final response = await api.post(
        EndPoints.userRegister,
        data: data,
        isFormData: true,
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, LoginModel>> verifyAccount({
    required String phone,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> data = {
        "phone": phone,
        "otp": otp,
      };

      final response = await api.post(
        EndPoints.userVerification,
        data: data,
        isFormData: true,
      );

      return Right(LoginModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, LoginModel>> resendOtp({
    required String phone,
  }) async {
    try {
      Map<String, dynamic> data = {
        "value": phone,
      };

      final response = await api.post(
        EndPoints.userSendOtp,
        data: data,
        isFormData: true,
      );

      return Right(LoginModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, List<User>>> checkRegisteredContacts({
    required List<String> phoneNumbers,
  }) async {
    try {
      final response = await api.get(
        EndPoints.checkContacts,
        data: {'phones': phoneNumbers},
        isFormData: false,
      );

      if (response.data['success'] == true) {
        final List<User> registeredUsers =
            (response.data['data'] as List<dynamic>)
                .map((e) => User.fromJson(e as Map<String, dynamic>))
                .toList();
        return Right(registeredUsers);
      } else {
        return Left(response.data['message'] ?? 'Unknown error');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
