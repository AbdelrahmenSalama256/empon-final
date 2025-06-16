import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/cart/data/model/cart_model.dart';

class CartRepo {
  final ApiConsumer api;

  CartRepo(this.api);

  Future<Either<String, CartResponseModel>> fetchCart() async {
    try {
      final response = await api.get(EndPoints.cart);
      final cartData = CartResponseModel.fromJson(response.data);
      return Right(cartData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch cart: $e');
    }
  }

  Future<Either<String, AddToCartResponseModel>> addProductToCart({
    required int productId,
    required int variationId,
    required int quantity, // Default quantity is 1
  }) async {
    try {
      final response = await api.post(
        EndPoints.addProductToCart,
        data: {
          'product_id': productId,
          'variation_id': variationId,
          'quantity': quantity,
        },
      );
      final addToCartData = AddToCartResponseModel.fromJson(response.data);
      return Right(addToCartData);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to add product to cart: $e');
    }
  }

  Future<Either<String, String>> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await api.patch(
        "${EndPoints.updateCartItemQuantity}/$cartItemId",
        data: {
          'quantity': quantity,
        },
      );
      return Right(response.data['message'] ?? 'Cart item quantity updated');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update cart item quantity: $e');
    }
  }

  Future<Either<String, String>> removeCartItem(int cartItemId) async {
    try {
      final response = await api.delete(
        "${EndPoints.removeCartItem}/$cartItemId",
      );
      return Right(response.data['message'] ?? 'Cart item removed');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to remove cart item: $e');
    }
  }
}
