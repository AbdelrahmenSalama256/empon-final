import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/notifications/data/model/notifications_model.dart';

class NotificationsRepo {
  final ApiConsumer api;

  NotificationsRepo(this.api);

  Future<Either<String, NotificationsModel>> getNotifications() async {
    try {
      final response = await api.get(EndPoints.notifications);
      final notificationsModel = NotificationsModel.fromJson(response.data);
      return Right(notificationsModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch notifications: $e');
    }
  }
}
