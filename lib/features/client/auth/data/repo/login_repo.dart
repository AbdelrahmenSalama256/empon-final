import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/notification/notification_handler.dart';
// import 'package:embone/core/notification/notification_handler.dart';
import 'package:embone/features/client/auth/data/models/login_model.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';

class LoginRepo {
  final ApiConsumer api;
  LoginRepo(this.api);

  Future<Either<String, LoginModel>> loginUser(
    String value,
    String password,
    String type,
  ) async {
    try {
      final response = await api.post(
        EndPoints.userLogin,
        data: {
          "value": value,
          "password": password,
          "type": type,
          "fcm_token": await NotificationHandler.getToken(),
        },
      );
      return Right(LoginModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, User>> getUserProfile() async {
    try {
      final response = await api.get(
        EndPoints.userProfile,
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        return Right(User.fromJson(responseData['data']));
      } else {
        return Left(responseData['message'] ?? 'Failed to fetch user profile');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  // Future<Either<String, User>> updateUserProfile({
  //   required String firstName,
  //   required String lastName,
  //   required String phone,
  //   required String email,
  //   required String gender,
  //   File? image,
  // }) async {
  //   try {
  //     final Map<String, dynamic> data = {
  //       'first_name': firstName,
  //       'last_name': lastName,
  //       'phone': phone,
  //       'email': email,
  //       'gender': gender,
  //     };

  //     if (image != null) {
  //       final multipartFile =
  //           await http.MultipartFile.fromPath('image', image.path);
  //       final response = await api.putMultipart(
  //         EndPoints.userProfile,
  //         data: data,
  //         files: [multipartFile],
  //       );
  //       final responseData = response.data as Map<String, dynamic>;
  //       if (responseData['success'] == true) {
  //         return Right(User.fromJson(responseData['data']));
  //       } else {
  //         return Left(
  //             responseData['message'] ?? 'Failed to update user profile');
  //       }
  //     } else {
  //       final response = await api.put(
  //         EndPoints.userProfile,
  //         data: data,
  //       );
  //       final responseData = response.data as Map<String, dynamic>;
  //       if (responseData['success'] == true) {
  //         return Right(User.fromJson(responseData['data']));
  //       } else {
  //         return Left(
  //             responseData['message'] ?? 'Failed to update user profile');
  //       }
  //     }
  //   } on ServerException catch (e) {
  //     return Left(e.errorModel.detail);
  //   } on NoInternetException catch (e) {
  //     return Left(e.errorModel.detail);
  //   }
  // }

  Future<Either<String, String>> userLogout() async {
    try {
      final response = await api.get(EndPoints.userLogout);
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['success'] == true) {
        return Right(responseData['message'] ?? 'Logged out successfully');
      } else {
        return Left(responseData['message'] ?? 'Failed to log out');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
