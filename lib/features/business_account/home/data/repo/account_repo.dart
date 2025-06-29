import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/home/data/models/business_account_model.dart';

class BusinessAccountRepo {
  final ApiConsumer api;

  BusinessAccountRepo(this.api);

  Future<Either<String, BusinessAccountResponse>> fetchBusinessAccountById(
      int accountId) async {
    try {
      final response = await api.get('${EndPoints.account}$accountId');
      return Right(BusinessAccountResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left("Unexpected error occurred: $e");
    }
  }
}
