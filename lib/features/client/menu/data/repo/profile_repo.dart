import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepo {
  final ApiConsumer api;

  ProfileRepo(this.api);

  Future<Either<String, String>> updateProfile({
    required String firstName,
    required String lastName,
    required String birthDate,
    required String gender,
    required String phone,
    required String email,
    String? anotherEmail,
    XFile? image,
  }) async {
    try {
      Map<String, dynamic> data = {
        "first_name": firstName,
        "last_name": lastName,
        "birth_date": birthDate,
        "gender": gender,
        "phone": phone,
        "email": email,
        if (anotherEmail != null) "another_email": anotherEmail,
      };

      if (image != null) {
        data['image'] =
            await MultipartFile.fromFile(image.path, filename: image.name);
      }

      final response = await api.post(
        EndPoints.updateProfile,
        data: data,
        isFormData: true,
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }

  Future<Either<String, String>> updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      Map<String, dynamic> data = {
        "old_password": oldPassword,
        "password": newPassword,
        "password_confirmation": confirmNewPassword,
      };

      final response = await api.post(
        EndPoints.updatePassword,
        data: data,
        isFormData: true,
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }
}
