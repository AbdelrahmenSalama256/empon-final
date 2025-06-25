import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/dashboard/data/models/statistics_model.dart';

class StatisticsRepo {
 final ApiConsumer api;

  StatisticsRepo(this.api);


  Future<Either<String, StatisticsResponse>> fetchStatistics(int? accountId) async {
    try {
      final response = await api.get('${EndPoints.statistics}$accountId');
      final stats = StatisticsResponse.fromJson(response.data);
      return Right(stats);
    } on DioException catch (e) {
      return Left(e.message ?? "Unknown error occurred");
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
