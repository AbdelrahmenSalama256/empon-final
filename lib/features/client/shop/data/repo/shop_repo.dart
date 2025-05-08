import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/shop/data/model/shop_response_model.dart';

class ShopRepo {
  final ApiConsumer api;

  ShopRepo(this.api);

  Future<Either<String, ShopResponseModel>> fetchShopData(
      double latitude, double longitude) async {
    try {
      final queryParameters = {
        'lat': latitude.toString(),
        'lng': longitude.toString()
      };
      final response =
          await api.get(EndPoints.shopNearby, queryParameters: queryParameters);
      final shopData = ShopResponseModel.fromJson(
          response.data); // Ensure response.data is used
      return Right(shopData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch shop data: $e');
    }
  }
}
