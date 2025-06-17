import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/constants/widgets/errors/failure.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<Either<String, AccountModel>> createAccountStepTwo({
    required String name,
    required String description,
    required String videoUrl,
    //required String website,
    required String email,
    required String phone,
    required String address,
    required String postalCode,
    required String lat,
    required String lng,
    required String cityId,
    required XFile logo,
    required XFile coverImage,
  }) async {
    try {
      Map<String, dynamic> data = {
        "description": description,
        "video_url": videoUrl,
        //"website": website,
        "email": email,
        "phone": phone,
        "city_id": cityId,
        "address": address,
        "postal_code": postalCode,
        "logo": await uploadImageToAPI(logo),
        "cover":  await uploadImageToAPI(coverImage) ,
        "lat": lat,
        "lng": lng,
      };

      final response = await api.post(
        EndPoints.createAccountStepTwo,
        isFormData: true,
        data: data,
      );

      return Right(AccountModel.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
