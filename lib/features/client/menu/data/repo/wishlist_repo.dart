import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/wishlist_model.dart';

class WishlistRepo {
  final ApiConsumer api;

  WishlistRepo(this.api);

  Future<Either<String, FavoritesResponseModel>> fetchFavorites() async {
    try {
      final response = await api.get(EndPoints.favorites);
      final favoritesData = FavoritesResponseModel.fromJson(response.data);
      return Right(favoritesData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch favorites: $e');
    }
  }

  Future<Either<String, String>> addProductToWishlist(int productId) async {
    try {
      final response = await api.post(
        EndPoints.addProductToWishlist,
        data: {'product_id': productId},
      );
      return Right(response.data['message'] ?? 'Product added to wishlist');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add product to wishlist: $e');
    }
  }

  Future<Either<String, String>> addAccountToWishlist(int accountId) async {
    try {
      final response = await api.post(
        EndPoints.addAccountToWishlist,
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
