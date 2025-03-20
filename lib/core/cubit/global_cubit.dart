import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  init() {}
  //! Bottom Navigation
  int currentNavIndex = 0;

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emit(BottomNavChangeState());
    }
  }

  //! Language
  String language = sl<CacheHelper>().getCachedLanguage();
  changeLanguage() {
    sl<CacheHelper>().getCachedLanguage() == "en"
        ? sl<CacheHelper>().cacheLanguage("ar")
        : sl<CacheHelper>().cacheLanguage("en");
    language = sl<CacheHelper>().getCachedLanguage();
    emit(LanguageChangeState());
    // Restart.restartApp();
  }

//! Location
  String? currentLocation;
  double currentLat = 30.062628785575555;
  double currentLong = 31.335285600000006;

  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        PrintUtil.error('Location services are disabled.');

        return;
      }
    }

    // Check for permission status
    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        PrintUtil.error('Location permission denied.');
        return;
      }
    }

    // Get the current location
    try {
      loc.LocationData locationData = await location.getLocation();

      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      // Convert coordinates to address
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

  //! User Data
  String? userName, userEmail, userAvatar, userPhone;
  int? userId, points;
  bool? userEmailVerified;
}
