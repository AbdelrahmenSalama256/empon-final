import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/checkout/data/model/cart_info_model.dart';

class CheckoutRepo {
  final ApiConsumer api;

  CheckoutRepo(this.api);

  Future<Either<String, CartInfoModel>> getCartInfo() async {
    try {
      final response = await api.get(EndPoints.cartInfo);
      final cartData = CartInfoModel.fromJson(response.data);
      return Right(cartData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch cart info: $e');
    }
  }
}
