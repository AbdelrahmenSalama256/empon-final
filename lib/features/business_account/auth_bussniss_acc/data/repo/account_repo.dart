import 'package:dartz/dartz.dart';
import 'package:embone/core/common/common.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/model/tostore_model.dart';
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
     String? address,
     String? postalCode,
     String? lat,
     String? lng,
     String? cityId,
    required XFile logo,
    required XFile coverImage,
  }) async {
    try {
      Map<String, dynamic> data = {
        "description": description,
        "video_url": videoUrl,
        "email": email,
        "phone": phone,
        if (cityId != null && cityId.isNotEmpty) "city_id": cityId,
        if (address != null && address.isNotEmpty) "address": address,
        if (postalCode != null && postalCode.isNotEmpty) "postal_code": postalCode,
        "logo": await uploadImageToAPI(logo),
        "cover": await uploadImageToAPI(coverImage),
        if (lat != null && lat.isNotEmpty) "lat": lat,
        if (lng != null && lng.isNotEmpty) "lng": lng,
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
  Future<Either<String, AccountModel>> updateAccountData(
    int id,
    String? name,
    String? description,
    String? videoUrl,
    String? email,
    String? phone,
    String? address,
    String? postalCode,
    String? lat,
    String? lng,
    String? cityId,
    
  ) async {
    try {
      final response = await api.post(
        '${EndPoints.updateAccountData}$id',
        data: {
            if (name != null && name.isNotEmpty) 'name': name,
            if (description != null && description.isNotEmpty) 'description': description,
            if (videoUrl != null && videoUrl.isNotEmpty) 'video_url': videoUrl,
            if (email != null && email.isNotEmpty) 'email': email,
            if (phone != null && phone.isNotEmpty) 'phone': phone,
            'city_id': cityId,
            'address': address,
            'postal_code': postalCode,
            'lat': lat,
            'lng':lng,
          '_method':'PUT'

        },
        isFormData: true,
      );

      return Right(AccountModel.fromJson(response.data['data']));


     } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
    }
    Future<Either<String, StoreRequestResponse>> requestBusinessToStore(
      int id,
    ) async {
    try {
      final response = await api.post(
        '${EndPoints.requestBusinessToStore}$id',);
        return Right(StoreRequestResponse.fromJson(response.data['data']));
    }on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }

    }

        Future<Either<String, StoreRequestResponse>> requestBusinessVirfication(
    int id,
  ) async {
    try {
      final response = await api.post(
        '${EndPoints.verificationRequest}$id',
      );
      return Right(StoreRequestResponse.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
   Future<Either<String, AccountModel>> updateImageAccountData(
    int id,
 {required XFile logo, required XFile coverImage}

  ) async {
    try {
      final response = await api.post(
        '${EndPoints.updateAccountData}$id',
        data: {
            if (logo.path.isNotEmpty) "logo": await uploadImageToAPI(logo),
            if (coverImage.path.isNotEmpty) "cover": await uploadImageToAPI(coverImage),
          '_method': 'PUT'
        },
        isFormData: true,
      );

      return Right(AccountModel.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }     
}
