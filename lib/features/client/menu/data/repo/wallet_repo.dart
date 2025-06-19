import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/wallet_history_model.dart';

import '../model/wallet_balance_model.dart';

class WalletRepo {
  final ApiConsumer api;

  WalletRepo(this.api);

  Future<Either<String, WalletHistoryResponseModel>>
      fetchWalletHistory() async {
    try {
      final response = await api.get(EndPoints.walletHistory);
      final walletData = WalletHistoryResponseModel.fromJson(response.data);
      return Right(walletData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch wallet history: $e');
    }
  }

  Future<Either<String, WalletBalanceResponseModel>>
      fetchWalletBalance() async {
    try {
      final response = await api.get(EndPoints.walletBalance);
      final walletData = WalletBalanceResponseModel.fromJson(response.data);
      return Right(walletData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch wallet balance: $e');
    }
  }
}
