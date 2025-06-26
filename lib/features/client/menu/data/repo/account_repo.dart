import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/account_model.dart';

class AccountsRepo {
  final ApiConsumer api;

  AccountsRepo(this.api);

  Future<Either<String, AccountResponseModel>> fetchAccountDetails(
      int accountId) async {
    try {
      final response = await api.get('${EndPoints.accounts}/$accountId');
      final accountData = AccountResponseModel.fromJson(response.data);
      return Right(accountData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch account details: $e');
    }
  }

  Future<Either<String, String>> followAccount(int accountId) async {
    try {
      final response = await api.post(
        EndPoints.accountsFollow,
        data: {'account_id': accountId},
      );
      return Right(response.data['message'] ?? 'Account added to wishlist');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add account to wishlist: $e');
    }
  }
}
