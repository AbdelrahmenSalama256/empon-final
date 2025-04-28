import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
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
          // "fcm_token": await NotificationHandler.getToken(),
        },
      );
      return Right(LoginModel.fromJson(response.data as Map<String, dynamic>));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
