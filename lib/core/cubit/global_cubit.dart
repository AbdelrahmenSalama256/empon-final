import 'dart:convert';
import 'dart:developer';

import 'package:embone/core/common/logs.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/menu/data/repo/address_repo.dart';
import 'package:embone/features/client/menu/data/repo/profile_repo.dart';
import 'package:embone/features/client/menu/data/repo/wishlist_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  User? user =
      sl<CacheHelper>().getDataString(key: AppConstants.userProfile) != null
          ? User.fromJson(jsonDecode(
              sl<CacheHelper>().getDataString(key: AppConstants.userProfile)!))
          : null;

  init() {
    userType =
        sl<CacheHelper>().getDataString(key: AppConstants.userType) == null
            ? UserType.client
            : UserType.values.firstWhere(
                (e) =>
                    e.name ==
                    sl<CacheHelper>().getDataString(key: AppConstants.userType),
                orElse: () => UserType.client,
              );
    emit(UserTypeLoadedState());
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    getCurrentLocation();
    getUserProfile();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController anotherEmailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController confrimNewPasswordController =
      TextEditingController();

  Gender selectedGender = Gender.male;
  XFile? profileImage;
  bool isLoading = false;

  void initProfileData() {
    firstNameController.text = userName ?? '';
    lastNameController.text = userLastName ?? '';
    phoneController.text = userPhone ?? '';
    emailController.text = userEmail ?? '';
    anotherEmailController.text = userAnotherEmail ?? '';
    birthDateController.text = userBirthDate ?? '';
    selectedGender = userGender == 'male'
        ? Gender.male
        : userGender == 'female'
            ? Gender.female
            : Gender.other;
    emit(ProfileLoaded());
  }

  UserType? userType;

  int currentNavIndex = 0;
  PersistentTabController controller = PersistentTabController();

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      controller.jumpToTab(index);
      emit(BottomNavChangeState());
    }
  }

  void setUserType(UserType type) {
    if (type != userType) {
      userType = type;
      sl<CacheHelper>().setData(AppConstants.userType, type.name);
      log(userType.toString());
      emit(UserTypeChangedState());
    }
  }

  String language = sl<CacheHelper>().getCachedLanguage();
  changeLanguage() async {
    sl<CacheHelper>().getCachedLanguage() == "en"
        ? await sl<CacheHelper>().cacheLanguage("ar")
        : await sl<CacheHelper>().cacheLanguage("en");
    language = sl<CacheHelper>().getCachedLanguage();
    log("language is $language");
    emit(LanguageChangeState());
  }

  String? currentLocation;
  double currentLat = 30.062628785575555;
  double currentLong = 31.335285600000006;

  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        PrintUtil.error('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        PrintUtil.error('Location permission denied.');
        return;
      }
    }

    try {
      loc.LocationData locationData = await location.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      final newAddress =
          "${place.subThoroughfare}${place.subThoroughfare == '' ? '' : ', '}"
                  "${place.thoroughfare}${place.thoroughfare == '' ? '' : ', '}"
                  "${place.subAdministrativeArea}${place.subAdministrativeArea == '' ? '' : ', '}"
                  "${place.administrativeArea}${place.administrativeArea == '' ? '' : ', '}"
                  "${place.country}"
              .trim();

      PrintUtil.warning('Current Location: $newAddress');
      PrintUtil.warning('Lat: $latitude, Lng: $longitude');
      currentLocation = newAddress;
      currentLat = latitude;
      currentLong = longitude;
    } on Exception catch (e) {
      PrintUtil.warning('Location request: $e');
    }
  }

  String? userName, userEmail, userId, userAvatar, userPhone;
  int? points;
  bool? userEmailVerified;
  String? userLastName,
      userBirthDate,
      userGender,
      userAnotherEmail,
      userBalance;
  bool? userAnotherEmailVerified, userPhoneVerified, userIsOnline;
  String? userFcmToken, userWsToken, userLastSeen, userCreatedAt;
  List<Address>? userAddresses;
  List<Account>? userAccount;
  int? businessId;
  Future<void> getUserProfile({bool forceRefresh = false}) async {
    emit(ProfileLoading());

    if (sl<CacheHelper>().getDataString(key: AppConstants.token) == null) {
      PrintUtil.error("No token found, user is not logged in.");
      emit(ProfileError("No token found, please log in."));
      return;
    }

    if (!forceRefresh && user != null) {
      PrintUtil.success(
          "Loaded user profile from cache: ${user!.firstName} ${user!.lastName}");
      _updateUserData(user!);
      emit(ProfileLoaded());
      _fetchAndUpdateProfile();
      return;
    }

    await _fetchAndUpdateProfile();
  }

  Future<void> _fetchAndUpdateProfile() async {
    final response = await sl<LoginRepo>().getUserProfile();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to get user profile: $failure");
        emit(ProfileError(failure));
      },
      (userData) {
        sl<CacheHelper>()
            .setData(AppConstants.userProfile, jsonEncode(userData.toJson()));
        user = userData;
        _updateUserData(userData);
        PrintUtil.success(
            "User profile fetched successfully: ${userData.firstName} ${userData.lastName}");
        PrintUtil.info(
            "Cached user profile: ${sl<CacheHelper>().getDataString(key: AppConstants.userProfile)}");
        emit(ProfileLoaded());
      },
    );
  }

  void _updateUserData(User userData) {
    userId = userData.id;
    userName = userData.firstName;
    userLastName = userData.lastName;
    userBirthDate = userData.birthDate;
    userGender = userData.gender;
    userPhone = userData.phone;
    userEmail = userData.email;
    userAnotherEmail = userData.anotherEmail;
    userAvatar = userData.image;
    userEmailVerified = userData.emailVerifiedAt;
    userAnotherEmailVerified = userData.anotherEmailVerifiedAt;
    userPhoneVerified = userData.phoneVerifiedAt;
    userBalance = userData.balance;
    userFcmToken = userData.fcmToken;
    userWsToken = userData.wsToken;
    userLastSeen = userData.lastSeen;
    userIsOnline = userData.isOnline;
    userCreatedAt = userData.createdAt;
    userAddresses = userData.addresses;
    userAccount = userData.account;
    initProfileData();
  }

  Future<void> logout() async {
    emit(LogoutLoading());

    if (sl<CacheHelper>().getDataString(key: AppConstants.token) == null) {
      PrintUtil.error("No token found, user is not logged in.");
      emit(LogoutError("No token found, please log in."));
      return;
    }

    final response = await sl<LoginRepo>().userLogout();
    response.fold(
      (failure) {
        PrintUtil.error("Failed to log out: $failure");
        emit(LogoutError(failure));
      },
      (message) {
        sl<CacheHelper>().clearData();
        user = null;
        PrintUtil.success("User logged out successfully: $message");
        emit(LogoutSuccess(message));
      },
    );
  }

  Future<void> updateUserProfile() async {
    if (isLoading) return;

    emit(ProfileLoading());
    isLoading = true;

    final response = await sl<ProfileRepo>().updateProfile(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      birthDate: birthDateController.text,
      gender: selectedGender.name,
      phone: phoneController.text,
      email: emailController.text,
      anotherEmail: anotherEmailController.text.isNotEmpty
          ? anotherEmailController.text
          : null,
      image: profileImage,
    );

    response.fold(
      (error) {
        PrintUtil.error("Profile update failed: $error");
        emit(ProfileError(error));
        isLoading = false;
      },
      (result) async {
        PrintUtil.success("Profile updated successfully!");
        userName = firstNameController.text;
        userLastName = lastNameController.text;
        userPhone = phoneController.text;
        userEmail = emailController.text;
        userGender = selectedGender.name;
        userAnotherEmail = anotherEmailController.text.isNotEmpty
            ? anotherEmailController.text
            : null;
        userBirthDate = birthDateController.text;
        profileImage = null;
        // await getUserProfile(forceRefresh: true);
        isLoading = false;
        emit(ProfileUpdated());
      },
    );
  }

  void setProfileImage(XFile? image) {
    profileImage = image;
    emit(ProfileDataUpdated());
  }

  void setGender(Gender gender) {
    selectedGender = gender;
    emit(ProfileDataUpdated());
  }

  Future<void> updatePasswordProfile() async {
    if (isLoading) return;

    emit(ProfileLoading());
    isLoading = true;

    final response = await sl<ProfileRepo>().updatePassword(
      confirmNewPassword: confrimNewPasswordController.text,
      newPassword: newPasswordController.text,
      oldPassword: oldPasswordController.text,
    );

    response.fold(
      (error) {
        PrintUtil.error("Profile update failed: $error");
        emit(ProfileError(error));
        isLoading = false;
      },
      (result) async {
        PrintUtil.success("Profile updated successfully!");
        // await getUserProfile(forceRefresh: true);
        isLoading = false;
        emit(ProfileUpdated());
      },
    );
  }

  Future<void> addProductToWishlist(int productId) async {
    emit(WishlistLoading());
    final response = await sl<WishlistRepo>().addProductToWishlist(productId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        emit(WishlistError(l));
      },
      (r) {
        emit(WishlistSuccess(r));
        PrintUtil.success(r);
      },
    );
  }

  Future<void> addAccountToWishlist(int accountId) async {
    emit(WishlistLoading());
    final response = await sl<WishlistRepo>().addAccountToWishlist(accountId);
    response.fold(
      (l) {
        PrintUtil.error(l);
        emit(WishlistError(l));
      },
      (r) {
        emit(WishlistSuccess(r));
        PrintUtil.success(r);
      },
    );
  }

  Future<void> updateAddress(int id, Address address) async {
    emit(ProfileLoading());
    final result = await sl<AddressRepo>().updateAddress(id, address);
    result.fold(
      (failure) {
        emit(ProfileError(failure));
      },
      (updatedAddress) {
        userAddresses = updatedAddress;
        user = user?.copyWith(addresses: userAddresses);
        sl<CacheHelper>()
            .setData(AppConstants.userProfile, jsonEncode(user?.toJson()));
        emit(ProfileUpdated());
      },
    );
  }

  Future<void> deleteAddress(int id) async {
    emit(ProfileLoading());
    final result = await sl<AddressRepo>().deleteAddress(id);
    result.fold(
      (failure) {
        emit(ProfileError(failure));
      },
      (message) {
        userAddresses =
            (user?.addresses ?? []).where((addr) => addr.id != id).toList();
        user = user?.copyWith(addresses: userAddresses);
        sl<CacheHelper>()
            .setData(AppConstants.userProfile, jsonEncode(user?.toJson()));
        emit(ProfileUpdated());
      },
    );
  }

  Future<void> fetchUserAddresses() async {
    emit(GetAddressLoading());
    final response = await sl<AddressRepo>().getUserAddresses();
    response.fold(
      (l) {
        Print.error(l);
        emit(GetAddressError(l));
      },
      (r) {
        userAddresses = r;
        emit(GetAddressSuccess());
      },
    );
  }

  Future<void> addAddress({
    required String address,
    required String city,
    required String lat,
    required String lng,
  }) async {
    emit(AddressLoading());
    final result = await sl<AddressRepo>().addAddress(
      address: address,
      city: city,
      lat: lat,
      lng: lng,
    );
    result.fold(
      (failure) {
        emit(AddressError(failure));
      },
      (newAddress) {
        final globalCubit = sl<GlobalCubit>();
        globalCubit.userAddresses = [
          ...(globalCubit.userAddresses ?? []),
          ...newAddress.map((addr) => Address.fromJson(addr.toJson()))
        ];
        globalCubit.user =
            globalCubit.user?.copyWith(addresses: globalCubit.userAddresses);
        sl<CacheHelper>().setData(
            AppConstants.userProfile, jsonEncode(globalCubit.user?.toJson()));
        emit(AddressSuccess());
      },
    );
  }
}

enum UserType {
  client,
  store,
  business,
}
