import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/model/account_model.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  final AccountRepo accountRepo;
  AccountModel? account;

  // Controllers for text fields
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final videoUrlController = TextEditingController();
  final websiteController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final postalCodeController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();

  String? selectedCityId;
  List<String> categoryIds = [];
  List<XFile> files = [];

  // City ID mapping
  final Map<String, String> cityIdMap = {
    'القاهرة': '1',
    'الجيزة': '2',
    'الإسكندرية': '3',
    'أسيوط': '4',
    'المنصورة': '5',
  };

  // Location-related fields
  LocationModel? selectedCountry;
  LocationModel? selectedState;
  LocationModel? selectedCity;
  List<LocationModel> allLocations = [];

  AccountCubit(this.accountRepo, {this.name}) : super(AccountInitial());
  final String? name;
  // Update text field values
  void updateName(String value) => nameController.text = value;
  void updateDescription(String value) => descriptionController.text = value;
  void updateVideoUrl(String value) => videoUrlController.text = value;
  void updateWebsite(String value) => websiteController.text = value;
  void updateEmail(String value) => emailController.text = value;
  void updatePhone(String value) => phoneController.text = value;
  void updateAddress(String value) => addressController.text = value;
  void updatePostalCode(String value) => postalCodeController.text = value;
  void updateLat(String value) => latController.text = value;
  void updateLng(String value) => lngController.text = value;

  // Update selected city with mapped ID
  void updateCityId(String? value) {
    selectedCityId = value != null ? cityIdMap[value] : null;
    emit(AccountUpdated());
  }

  void updateCategoryIds(List<String> newCategoryIds) {
    categoryIds = List.from(newCategoryIds);
    emit(AccountUpdated());
  }

  // Add category IDs
  void addCategoryId(String value) {
    if (!categoryIds.contains(value)) {
      categoryIds.add(value);
    }
    emit(AccountUpdated());
    log(categoryIds.toString());
  }

  // Remove category ID
  void removeCategoryId(String value) {
    categoryIds.remove(value);
    emit(AccountUpdated());
  }

  // Pick files
  Future<void> pickFiles() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      files.addAll(pickedFiles.map((file) => XFile(file.path)));
      emit(AccountUpdated());
    }
  }

  // Remove file
  void removeFile(XFile file) {
    files.remove(file);
    emit(AccountUpdated());
  }

  // Location-related methods
  Future<void> fetchAllLocations() async {
    emit(LocationsLoading());
    final response = await accountRepo.getAllLocations();
    response.fold(
      (error) => emit(LocationsError(error.errMessage)),
      (locations) {
        allLocations = locations;
        emit(CountriesLoaded(
            locations.where((loc) => loc.countryId == 0).toList()));
      },
    );
  }

  List<LocationModel> getFilteredStates() {
    if (selectedCountry == null) return [];
    return allLocations
        .where(
            (loc) => loc.countryId == selectedCountry!.id && loc.stateId == 0)
        .toList();
  }

  List<LocationModel> getFilteredCities() {
    if (selectedState == null) return [];
    return allLocations
        .where((loc) => loc.stateId == selectedState!.id)
        .toList();
  }

  void setCountry(LocationModel country) {
    selectedCountry = country;
    selectedState = null;
    selectedCity = null;
    emit(AccountUpdated());
  }

  void setGovernorate(LocationModel state) {
    selectedState = state;
    selectedCity = null;
    emit(AccountUpdated());
  }

  void setCity(LocationModel city) {
    selectedCity = city;
    selectedCityId = city.id.toString();
    emit(AccountUpdated());
  }

  void setLocation(String address, String lat, String lng) {
    addressController.text = address;
    latController.text = lat;
    lngController.text = lng;
    emit(AccountUpdated());
  }

  Future<void> createAccountStepOne() async {
    emit(AccountLoading());

    final response = await accountRepo.createAccountStepOne(
      name: name ?? "",
      categoryIds: categoryIds,
    );

    response.fold(
      (l) {
        Print.error('API Error (Step 1): $l');
        emit(AccountError(massage: l));
      },
      (r) {
        account = r;
        Print.success(
            'Account step one completed successfully: ${r.toString()}');
        emit(AccountStepOneCompleted());
      },
    );
  }
}
