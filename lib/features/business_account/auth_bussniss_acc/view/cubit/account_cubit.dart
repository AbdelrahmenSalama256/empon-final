import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:embone/features/client/locations/data/repo/locations_repo.dart';
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


    List<LocationModel> allCountries = [];
  List<LocationModel> allStates = [];
  List<LocationModel> allCities = [];

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
  String? city;
  String? stat;
  String? country;


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
    PrintUtil.info("Fetching all locations...");
   emit(LocationsLoading());

    final countriesResponse = await sl<LocationRepo>().getCountries();
    countriesResponse.fold(
      (error) {
        Print.error("Failed to fetch countries: $error");
        emit(LocationsError(error));
      },
      (countries) {
        PrintUtil.info("Fetched $countries ");
        allCountries = countries;
        Print.info("Fetched ${allCountries.length} countries");
      },
    );

    final statesResponse = await sl<LocationRepo>().getStates();
    statesResponse.fold(
      (error) {
        Print.error("Failed to fetch states: $error");
        emit(LocationsError(error));
      },
      (states) {
        allStates = states;
        Print.info("Fetched ${allStates.length} states");
      },
    );

    final citiesResponse = await sl<LocationRepo>().getCities();
    citiesResponse.fold(
      (error) {
        Print.error("Failed to fetch cities: $error");
        emit(LocationsError(error));
      },
      (cities) {
        allCities = cities;
        Print.info("Fetched ${allCities.length} cities");
        emit(CountriesLoaded(allCountries));
      },
    );
  }

List<LocationModel> getFilteredStates() {
    if (selectedCountry == null) return [];
    return allStates
        .where((state) => state.countryId == selectedCountry!.id)
        .toList();
  }

  List<LocationModel> getFilteredCities() {
    if (selectedState == null) return [];
    return allCities
        .where((city) => city.stateId == selectedState!.id)
        .toList();
  }

  void setCountry(LocationModel? country) {
    selectedCountry = country;
    selectedState = null;
    selectedCity = null;
    Print.info("Set country: ${country?.name} (ID: ${country?.id})");
    emit(CountriesLoaded(allCountries));
  }

  void setGovernorate(LocationModel? state) {
    selectedState = state;
    selectedCity = null;
    Print.info("Set governorate: ${state?.name} (ID: ${state?.id})");
    emit(StatesLoaded(getFilteredStates()));
  }

  void setCity(LocationModel? city) {
    selectedCity = city;
    Print.info("Set city: ${city?.name} (ID: ${city?.id})");

    emit(CitiesLoaded(getFilteredCities()));
  }
    void setLocation(String address, String latitude, String longitude) {
    addressController.text = address;
    latController.text = latitude;
    lngController.text = longitude;
    Print.info("Set location: Address: $address, Lat: $latController, Lng: $lngController");
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
  Future<void> createAccountStepTwo() async {
    emit(AccountLoading());

    final response = await accountRepo.createAccountStepTwo(
      name: nameController.text,
      description: descriptionController.text,
      videoUrl: videoUrlController.text,
  //website: websiteController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: addressController.text,
      postalCode: postalCodeController.text,
      lat: latController.text,
      lng: lngController.text,
      cityId:selectedCity?.id.toString()  ?? "",
      logo: files.isNotEmpty ? files[0] : XFile(''),
      coverImage: files.length > 1 ? files[1] : XFile(''),
    );

    response.fold(
      (l) {
        Print.error('API Error (Step 2): $l');
        emit(AccountError(massage: l));
      },
      (r) {
        account = r;
        Print.success(
            'Account step two completed successfully: ${r.toString()}');
        emit(AccountSuccess());
      },
    );
  }
  Future<void> sendStoreRequest({required int accountId}) async {
    emit(StoreRequestLoading());

    try {
      final response = await accountRepo.requestBusinessToStore(accountId);

      response.fold(
        (l) {
          Print.error('API Error: $l');
          emit(StoreRequestError(l));
        },
        (r) {
          emit(StoreRequestSuccess(r.data));
        },
      );
    } on ServerException catch (e) {
      emit(StoreRequestError(e.errorModel.detail));
    } on NoInternetException catch (e) {
      emit(StoreRequestError(e.errorModel.detail));
    } catch (e) {
      emit(StoreRequestError("Something went wrong"));
    }

   }
    Future<void> updateAccount({required int accountId}) async {
    emit(AccountLoading());

    final response = await accountRepo.updateAccountData(
        accountId,
        nameController.text,
        descriptionController.text,
        videoUrlController.text,
        emailController.text,
        phoneController.text,
        addressController.text,
        postalCodeController.text,
        latController.text,
        lngController.text,
        selectedCity?.id.toString() ?? "");

    response.fold(
      (l) {
        Print.error('API Error (Update): $l');
        emit(AccountError(massage: l));
      },
      (r) {
        emit(AccountSuccess());
      },
    );
  }
  
  Future<void> sendVerficationRequest({required int accountId}) async {
    emit(StoreRequestLoading());

    try {
      final response = await accountRepo.requestBusinessVirfication(accountId);

      response.fold(
        (l) {
          Print.error('API Error: $l');
          emit(StoreRequestError(l));
        },
        (r) {
          emit(StoreRequestSuccess(r.data));
        },
      );
    } on ServerException catch (e) {
      emit(StoreRequestError(e.errorModel.detail));
    } on NoInternetException catch (e) {
      emit(StoreRequestError(e.errorModel.detail));
    } catch (e) {
      emit(StoreRequestError("Something went wrong"));
    }
  }
  void initControllers({Account? model}) {
    if (model != null) {
      emit(AccountLoading());
      nameController.text = model.name!;
      descriptionController.text = model.description!;
      videoUrlController.text = model.videoUrl!;
      emailController.text = model.email! ;
      phoneController.text = model.phone! ;
      addressController.text = model.address!;
      postalCodeController.text = model.postalCode!;
      latController.text = model.lat.toString();
      lngController.text = model.lng.toString() ;
      city = model.city!;
      stat = model.state!;
      country = model.country!;

      emit(AccountUpdated());
    } else {
      nameController.clear();
      descriptionController.clear();
      videoUrlController.clear();
      websiteController.clear();
      emailController.clear();
      phoneController.clear();
      addressController.clear();
      postalCodeController.clear();
      latController.clear();
      lngController.clear();
      categoryIds.clear();
      files.clear();
      selectedCity = null;
      selectedState = null;
      selectedCountry = null;
      emit(AccountUpdated());
    }
  }

}
