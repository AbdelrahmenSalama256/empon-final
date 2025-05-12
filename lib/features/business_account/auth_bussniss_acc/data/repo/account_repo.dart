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

  Future<Either<String, AccountModel>> createAccount({
    required List<XFile> files,
    required String name,
    required String description,
    required String videoUrl,
    required String website,
    required String email,
    required String phone,
    required String cityId,
    required String address,
    required String postalCode,
    required List<String> categoryIds,
    required String lat,
    required String lng,
  }) async {
    try {
      // Prepare the form data
      Map<String, dynamic> data = {
        "name": name,
        "description": description,
        "video_url": videoUrl,
        "website": website,
        "email": email,
        "phone": phone,
        "city_id": cityId,
        "address": address,
        "postal_code": postalCode,
        "category_ids[]": categoryIds,
        "lat": lat,
        "lng": lng,
      };

      // Handle file uploads
      if (files.isNotEmpty) {
        List<dynamic> uploadedFiles = [];
        for (var file in files) {
          uploadedFiles.add(await uploadImageToAPI(file));
        }
        data['files'] = uploadedFiles;
      }

      // Make the API call
      final response = await api.post(
        EndPoints.createAccount,
        data: data,
        isFormData: true,
      );

      return Right(AccountModel.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<Failure, List<LocationModel>>> getAllLocations() {
    // TODO: implement getAllLocations
    throw UnimplementedError();
  }
}
