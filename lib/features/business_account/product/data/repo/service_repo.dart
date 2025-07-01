import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/product/data/model/service_category_model.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:image_picker/image_picker.dart';

class ServiceRepo {
  final ApiConsumer api;

  ServiceRepo(this.api);

  Future<Either<String, ServiceModel>> createService({
    required String name,
    required String details,
    required String price,
    required int categoryServiceId,
    required int accountId,
    required XFile mainImage,
    required List<XFile> listImages,
    required List<String> about,
  }) async {
    try {
      final response = await api.post(
        EndPoints.addService,
        isFormData: true,
        data: {
          "name": name,
          "details": details,
          "price": price,
          "category_service_id": categoryServiceId,
          "account_id": accountId,
          "main_image": await uploadImageToAPI(mainImage),
          "list_images[]":
              await Future.wait(listImages.map((img) => uploadImageToAPI(img))),
          "features[]": about
        },
      );
      return Right(ServiceModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ServiceModel>> deleteServise(int id) async {
    try {
      final response = await api.delete('${EndPoints.updateService}$id');
      return Right(ServiceModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ServiceModel>> updateService({
    required int serviceId,
    int? accountId,
    String? name,
    String? details,
    String? price,
    int? categoryServiceId,
    XFile? mainImage,
    List<XFile>? listImages,
    List<String>? about,
  }) async {
    try {
      final data = {
        "account_id": accountId,
        "name": name,
        "details": details,
        "price": price,
        "category_service_id": categoryServiceId,
        "features[]": about
      };

      if (mainImage != null) {
        data["main_image"] = await uploadImageToAPI(mainImage);
      }

      if (listImages != null && listImages.isNotEmpty) {
        for (int i = 0; i < listImages.length; i++) {
          data["list_images[$i]"] = await uploadImageToAPI(listImages[i]);
        }
      }

      final response = await api.post(
        '${EndPoints.updateService}$serviceId',
        isFormData: true,
        data: data,
      );

      return Right(ServiceModel.fromJson(
          response.data)); // todo:wait end point to get response
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ServiceModel>> fetchServiceById(int serviceId) async {
    try {
      final response = await api.get(
        '${EndPoints.getService}/$serviceId',
      );
      return Right(ServiceModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ServicesResponse>> fetchServicesByAccountId() async {
    try {
      final response = await api.get(EndPoints.addService);
      return Right(ServicesResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, ServiceCategoryModel>> fetchServiceCategories() async {
    try {
      final response = await api.get(
        EndPoints.getServicesCategores,
      );
      return Right(ServiceCategoryModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
