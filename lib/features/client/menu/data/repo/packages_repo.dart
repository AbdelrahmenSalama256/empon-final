import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/cities_model.dart';
import 'package:embone/features/client/menu/data/model/packages_model.dart';

class PackagesRepo {
  final ApiConsumer api;

  PackagesRepo(this.api);

  Future<Either<String, PackagesResponse>> fetchPackages() async {
    try {
      final response = await api.get(
        EndPoints.packages,
      );
      final packagesData = PackagesResponse.fromJson(response.data);
      return Right(packagesData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch offers: $e');
    }

}

    Future<Either<String, CitiesResponse>> fetchCities() async {
    try {
      final response = await api.get(
        EndPoints.cities,
      );
      final citiesData = CitiesResponse.fromJson(response.data);
      return Right(citiesData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch offers: $e');
    }
  }
}
