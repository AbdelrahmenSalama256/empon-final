import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/offers_model.dart';

class OfferRepo {
  final ApiConsumer api;

  OfferRepo(this.api);

  Future<Either<String, OfferModel>> fetchOffers(
      {int? page, int? limit}) async {
    try {
      Map<String, dynamic> queryParameters = {};
      if (page != null) {
        queryParameters.addAll({'page': page});
      }
      if (limit != null) {
        queryParameters.addAll({'per_page': limit});
      }
      final response = await api.get(
        "${EndPoints.offers}/all",
        queryParameters: queryParameters,
      );
      final offerData = OfferModel.fromJson(response.data);
      return Right(offerData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch offers: $e');
    }
  }
}
