import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/home/data/model/home_model.dart';
import 'package:embone/features/client/home/data/model/service_model.dart';

class HomeRepo {
  final ApiConsumer api;

  HomeRepo(this.api);

  Future<Either<String, HomeModel>> getHomeData(
      {int page = 1, int limit = 10}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': page,
        'limit': limit,
      };
      final response = await api.get(
        EndPoints.home,
        queryParameters: queryParameters,
      );
      return Right(HomeModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch home data: $e');
    }
  }

  Future<Either<String, List<ServiceModel>>> getServices(
      {int limit = 10, int page = 1}) async {
    try {
      Map<String, dynamic> queryParameters = {
        'limit': limit,
        'page': page,
      };
      final response = await api.get(
        EndPoints.homeService,
        queryParameters: queryParameters,
      );
      return Right(serviceModelFromJson(jsonEncode(response.data)));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch services: $e');
    }
  }
}
