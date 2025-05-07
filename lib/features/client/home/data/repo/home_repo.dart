import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/home/data/model/home_model.dart';

class HomeRepo {
  final ApiConsumer api;

  HomeRepo(this.api);

  Future<Either<String, HomeModel>> getHomeData() async {
    try {
      final response = await api.get(EndPoints.home);
      final homeModel = HomeModel.fromJson(response.data);
      return Right(homeModel);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch home data: $e');
    }
  }
}
