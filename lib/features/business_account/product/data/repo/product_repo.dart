import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/product/data/model/product_category_model.dart';
import 'package:embone/features/business_account/product/data/model/product_model.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepo {
  final ApiConsumer api;

  ProductRepo(this.api);
  // Define methods for interacting with store products here
  Future<Either<String, ProductModel>> addProduct(
    int accountId,
    String name,
    String description,
    String price,
    int categoryId,
    int isSale,
    XFile productImage,
    List<XFile> productImages,
    List<Map<String, dynamic>> variations,
    List<Map<String, dynamic>> serviceDetails
  ) async {
    try {
      final response = await api.post(EndPoints.addProduct, data: {
        "account_id": accountId,
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "is_sale": isSale,
        "product_image": await uploadImageToAPI(productImage),
        "product_images[]": await Future.wait(
            productImages.map((img) => uploadImageToAPI(img))),
     "variations": variations,
     "details":serviceDetails

      }, isFormData: true);
      return Right(ProductModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ProductModel>> updateProduct(
    int productId, {
    int? accountId,
    String? name,
    String? description,
    String? price,
    int? categoryId,
    int? isSale,
    XFile? productImage,
    List<XFile>? productImages,
List<Map<String, dynamic>>? variations,
      List<Map<String, dynamic>>? serviceDetails
  }) async {
    try {
      final data = {
        "account_id": accountId,
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "is_sale": isSale,
        "product_image":
            productImage != null ? await uploadImageToAPI(productImage) : null,
        "product_images": productImages != null
            ? await Future.wait(
                productImages.map((img) => uploadImageToAPI(img)))
            : null,
        "variations": variations,
        "details": serviceDetails
      };
      final response = await api.put(
        "${EndPoints.updateProduct}$productId",
        data: data,
        isFormData: true,
      );
      return Right(ProductModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ProductModel>> deleteProduct(int productId) async {
    try {
      final response = await api.delete(
        "${EndPoints.deleteProduct}$productId",
      );
      return Right(ProductModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ProductResponse>> fetchAccountProductsById(
      int accountId) async {
    try {
      final response = await api
          .get('${EndPoints.getProducts}$accountId'); // Replace with correct endpoint
      return Right(ProductResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }

Future<Either<String, List<Category>>> fetchCategories() async {
    try {
      Response response = await api.get(EndPoints.productCategories);
      final data = CategoryResponse.fromJson(response.data);
      return Right(data.data);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left("Unexpected error: ${e.toString()}");
    }
  }

}



