import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';

class LocationRepo {
  final ApiConsumer api;

  LocationRepo(this.api);

  Future<Either<String, List<LocationModel>>> getCountries() async {
    try {
      final response = await api.get(EndPoints.countries);
      final data = response.data['data'] as List;
      final countries =
          data.map((json) => LocationModel.fromJson(json)).toList();
      return Right(countries);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch countries: $e');
    }
  }

  Future<Either<String, List<LocationModel>>> getStates() async {
    try {
      final response = await api.get(EndPoints.states);
      final data = response.data['data'] as List;
      final states = data.map((json) => LocationModel.fromJson(json)).toList();
      return Right(states);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch states: $e');
    }
  }

  Future<Either<String, List<LocationModel>>> getCities() async {
    try {
      final response = await api.get(EndPoints.cities);
      final data = response.data['data'] as List;
      final cities = data.map((json) => LocationModel.fromJson(json)).toList();
      return Right(cities);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch cities: $e');
    }
  }
}
