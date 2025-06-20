import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/features/business_account/product/data/model/service_category_model.dart';
import 'package:embone/features/business_account/product/data/model/service_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';


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
          "logo": await uploadImageToAPI(mainImage),
          "main_image": await uploadImageToAPI(mainImage),
          "list_images[]": await Future.wait(listImages.map((img) => uploadImageToAPI(img))),
        },
      );
      return Right(ServiceModel.fromJson(response));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }

    
  }
  
  Future<Either<String, ServiceCategoryModel>> fetchServiceCategories() async {
    try {
      final response =
          await api.get(
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
