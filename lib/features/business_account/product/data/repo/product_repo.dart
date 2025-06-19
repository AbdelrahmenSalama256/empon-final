import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
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
    int priceVariations,
    int stockVariation,
    int attributeValueId,
    List<String> colorId,
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
        "product_images": await Future.wait(
            productImages.map((img) => uploadImageToAPI(img))),
        "variations[][price]": priceVariations,
        "variations[][stock]": stockVariation,
        "variations[][attribute_value_id]": attributeValueId,
        "variations[][color_id]": colorId,
      });
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
    int? priceVariations,
    int? stockVariation,
    int? attributeValueId,
    List<String>? colorId,
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
        "variations[][price]": priceVariations,
        "variations[][stock]": stockVariation,
        "variations[][attribute_value_id]": attributeValueId,
        "variations[][color_id]": colorId,
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
}
