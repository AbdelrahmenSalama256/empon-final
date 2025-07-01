import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/ads_pack_model.dart';
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

  Future<Either<String,PackageAdsResponse>> createPackageWithAds({
    required int packageId,
    required int accountId,
    required List<int> productIds,
    required String genderFilter,
    required int minAge,
    required int maxAge,
    required int cityId,
    required String startDate,
    required String endDate,
  }) async {
   try {final body = {
      "package_id": packageId,
      "account_id": accountId,
      "product_ids": productIds,
      "gender_filter": genderFilter,
      "min_age": minAge,
      "max_age": maxAge,
      "city_id": cityId,
      "start_date": startDate,
      "end_date": endDate,
    };

    final response =
        await api.post(EndPoints.adsPack, data: body);
    return Right(PackageAdsResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch offers: $e');
    }
  }
}
