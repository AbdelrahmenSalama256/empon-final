import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/menu/data/model/ads_pack_model.dart';
import 'package:embone/features/client/menu/data/model/cities_model.dart';
import 'package:embone/features/client/menu/data/model/packages_model.dart';
import 'package:embone/features/client/menu/data/repo/packages_repo.dart';
import 'package:embone/features/client/menu/view/cubit/packages_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepo packagesRepo;
  List<PackageModel> packages = [];
  List<City> cities = [];
  String? slectedGander;
  int? selectedCityId;
  TextEditingController? maxAge = TextEditingController();
  TextEditingController? minAge = TextEditingController();
  PackageAdsData? packageAdsResponse;
  List<int> selectedItems = [];
  
 String? startDate;
 String? endDate;

  String? selectedAudience;
  String? selectedType;
  String? selectedCategory;


  PackagesCubit(this.packagesRepo) : super(PackagesInitial());
  void init() {
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    if (isClosed) return;

    emit(PackagesLoading());
    Print.info("Starting to fetch Packages");

    final result = await packagesRepo.fetchPackages();

    if (isClosed) return;

    result.fold(
      (error) {
        Print.error("Failed to fetch Packages: $error");
        emit(PackagesError(error.toString()));
      },
      (packagesResponse) {
        packages = packagesResponse.data;
        emit(PackagesLoaded(packages));
      },
    );
  }

  Future<void> fetchCities() async {
    final result = await packagesRepo.fetchCities();
    if (kDebugMode) {
      print(result);
    }
    result.fold(
      (error) {
        PrintUtil.error("Failed to fetch Packages: $error");
        emit(CitiesError(error.toString()));
      },
      (citiesResponse) {
        cities = citiesResponse.data;
        PrintUtil.success(cities.toString());
        emit(CitiesLoaded(cities));
      },
    );
  }

  Future<void> createPackageAds({
    required int packageId,
    required int accountId,
  }) async {
    if (isClosed) return;

    emit(PackageAdsLoading());

    
      final result = await packagesRepo.createPackageWithAds(
        packageId: packageId,
        accountId: accountId,
        productIds: selectedItems,
        genderFilter: slectedGander!,
        minAge: int.tryParse(minAge?.text ?? '') ?? 0,
        maxAge: int.tryParse(maxAge?.text ?? '') ?? 0,
        cityId: selectedCityId!,
        startDate: startDate!,
        endDate: endDate!,
      );

      if (isClosed) return;

     result.fold(
      (error) {
        PrintUtil.error("Failed to fetch Packages: $error");
        emit(PackageAdsError(error.toString()));
      },
      (response) {
        packageAdsResponse = response.data;
        emit(PackageAdsLoaded(packageAdsResponse!));
      }
    );
  }

}
