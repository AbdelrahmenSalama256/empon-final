import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/constants/widgets/errors/failure.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';

import '../model/account_model.dart';

class AccountRepo {
  final ApiConsumer api;

  AccountRepo(this.api);

  Future<Either<String, AccountModel>> createAccountStepOne({
    required String name,
    required List<String> categoryIds,
  }) async {
    try {
      Map<String, dynamic> data = {
        "name": name,
        "category_ids": categoryIds.toList(),
      };

      final response = await api.post(
        EndPoints.createAccountStepOne,
        data: data,
      );

      return Right(AccountModel.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<Failure, List<LocationModel>>> getAllLocations() {
    // TODO: implement getAllLocations
    throw UnimplementedError();
  }
}
