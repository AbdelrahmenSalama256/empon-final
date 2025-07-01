import 'package:embone/core/database/api/dio_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/menu/data/model/ads_pack_model.dart';

class PackageAdsRepo {
  final DioConsumer api;

  PackageAdsRepo(this.api);

  Future<PackageAdsResponse> createPackageWithAds({
    required int packageId,
    required int accountId,
    required List<int> productIds,
    required String genderFilter,
    required int minAge,
    required int maxAge,
    required int countryId,
    required int cityId,
    required String startDate,
    required String endDate,
    required String displayStartTime,
    required String displayEndTime,
  }) async {
    final body = {
      "package_id": packageId,
      "account_id": accountId,
      "product_ids": productIds,
      "gender_filter": genderFilter,
      "min_age": minAge,
      "max_age": maxAge,
      "city_id": cityId,
      "start_date": startDate,
      "end_date": endDate,
      "display_start_time": displayStartTime,
      "display_end_time": displayEndTime,
    };

    final response = await api.post(EndPoints.adsPack, data: body , isFormData: true);
    return PackageAdsResponse.fromJson(response.data);
  }
}
