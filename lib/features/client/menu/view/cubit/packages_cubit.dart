import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/menu/data/model/cities_model.dart';
import 'package:embone/features/client/menu/data/model/packages_model.dart';
import 'package:embone/features/client/menu/data/repo/packages_repo.dart';
import 'package:embone/features/client/menu/view/cubit/packages_state.dart';
import 'package:flutter/material.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepo packagesRepo;
  List<PackageModel> packages = [];
  List<City> cities = [];
  String? slectedGander;
  int? selectedCityId;
  TextEditingController? maxAge = TextEditingController();
  TextEditingController? minAge = TextEditingController();

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
    print(result);
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

}
