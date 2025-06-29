import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/total_sales_model.dart';

class TotalSalesRepo {
  final ApiConsumer api;

  TotalSalesRepo(this.api);

  Future<Either<String, StatisticsResponse>> fetchStatistics({
    required String type, 
    required String date,
  }) async {
    try {
      final response = await api.get(
        EndPoints.sellerStatistics,
        data: {
          'type': type,
          'date': date,
        },
      );

      final data = StatisticsResponse.fromJson(response.data);
      return Right(data);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch : $e');
    }
  }
}
