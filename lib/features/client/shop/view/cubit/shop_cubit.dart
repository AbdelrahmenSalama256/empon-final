import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/shop/data/model/shop_response_model.dart';
import 'package:embone/features/client/shop/data/repo/shop_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

part 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepo shopRepo;
  ShopResponseModel? shopData;
  String selectedCategory = 'shoes';
  double? latitude;
  double? longitude;
  final Location _location = Location();

  ShopCubit(this.shopRepo) : super(ShopInitial()) {
    init();
  }

  void init() async {
    await _getCurrentLocation();
    if (latitude != null && longitude != null) {
      fetchShopData(latitude!, longitude!);
    } else {
      emit(const ShopError('Failed to get location'));
    }
  }

  Future<void> _getCurrentLocation() async {
    emit(ShopLoading());
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          emit(const ShopError('Location services not enabled'));
          return;
        }
      }

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          emit(const ShopError('Location permissions denied'));
          return;
        }
      }

      LocationData locationData = await _location.getLocation();
      latitude = locationData.latitude;
      longitude = locationData.longitude;
    } catch (e) {
      Print.error('Error getting location: $e');
      emit(ShopError('Error getting location: $e'));
    }
  }

  Future<void> fetchShopData(double latitude, double longitude) async {
    emit(ShopLoading());
    final response = await shopRepo.fetchShopData(latitude, longitude);
    Print.info(response);

    response.fold(
      (l) {
        Print.error(l);
        emit(ShopError(l));
      },
      (r) {
        shopData = r;
        // Set selectedCategory to the first category if available
        if (shopData?.data?.categories?.isNotEmpty ?? false) {
          selectedCategory =
              shopData!.data!.categories!.first.category?.name ?? 'shoes';
        }
        Print.info(shopData);
        Print.success('Shop data fetched successfully');
        emit(ShopSuccess());
      },
    );
  }

  void updateCategory(String category) {
    selectedCategory = category;
    emit(ShopSuccess());
  }
}
