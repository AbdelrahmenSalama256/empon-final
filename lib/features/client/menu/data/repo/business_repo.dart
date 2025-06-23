import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/business_recent_view_model.dart';

class BusinessRepo {
  final ApiConsumer api;

  BusinessRepo(this.api);

  Future<Either<String, BusinessResponseModel>> fetchBusinesses() async {
    try {
      final response = await api.get(EndPoints.recentViewBrands);
      final businessData = BusinessResponseModel.fromJson(response.data);
      return Right(businessData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch businesses: $e');
    }
  }
}
