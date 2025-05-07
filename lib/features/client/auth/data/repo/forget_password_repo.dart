import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/auth/data/models/forget_password_model.dart';

class ForgetPasswordRepo {
  final ApiConsumer api;

  ForgetPasswordRepo(this.api);

  Future<Either<String, ForgotPasswordData>> forgotPassword(
      String value) async {
    try {
      final response = await api.post(
        EndPoints.forgotPassword,
        data: {"value": value},
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['message'] == "success") {
        return Right(ForgotPasswordData.fromJson(responseData['data']));
      } else {
        return Left(
            responseData['message'] ?? 'Failed to initiate password reset');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> verifyOtp(String value, String otp) async {
    try {
      final response = await api.post(
        EndPoints.verifyOtpForgotPassword,
        data: {"value": value, "otp": otp},
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['message'] == "success") {
        return Right(responseData['message'] ?? 'OTP verified successfully');
      } else {
        return Left(responseData['message'] ?? 'Failed to verify OTP');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> resetPassword(
      String value, String password, String passwordConfirmation) async {
    try {
      final response = await api.post(
        EndPoints.resetPassword,
        data: {
          "value": value,
          "password": password,
          "password_confirmation": passwordConfirmation
        },
      );
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['message'] == "success") {
        return Right(responseData['message'] ?? 'Password reset successful');
      } else {
        return Left(responseData['message'] ?? 'Failed to reset password');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
