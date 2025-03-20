import 'dart:async';
import 'dart:convert';

import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class SelectLocationMapPage extends StatefulWidget {
  final String? initialAddress;
  final double? initialLat;
  final double? initialLng;

  const SelectLocationMapPage({
    super.key,
    this.initialAddress,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<SelectLocationMapPage> createState() => _SelectLocationMapPageState();
}

class _SelectLocationMapPageState extends State<SelectLocationMapPage> {
  LatLng? _markerPosition;
  String? _address;
  CameraPosition? _initialCameraPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  bool _isMapLoaded = false;
  bool _isAddressSelected = false;

  @override
  void initState() {
    super.initState();
    // Delay initialization to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeLocation();
    });
  }

  void _initializeLocation() {
    final globalCubit = context.read<GlobalCubit>();

    // Use provided coordinates or fall back to current location
    final initialLat = widget.initialLat ?? globalCubit.currentLat;
    final initialLong = widget.initialLng ?? globalCubit.currentLong;

    _markerPosition = LatLng(initialLat, initialLong);
    _address = widget.initialAddress ??
        globalCubit.currentLocation ??
        'unknown_address'.tr(context);

    _initialCameraPosition = CameraPosition(
      target: _markerPosition!,
      zoom: 17,
    );

    // Add initial marker
    _markers.add(
      Marker(
        markerId: const MarkerId('selectedLocation'),
        position: _markerPosition!,
        infoWindow: InfoWindow(title: 'selected_location'.tr(context)),
      ),
    );

    // If we have an initial address, consider it selected
    _isAddressSelected = widget.initialAddress != null;

    setState(() {});
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _address =
              '${place.name ?? ''}, ${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
          _address = _address!
              .replaceAll(RegExp(r', ,'), ',')
              .replaceAll(RegExp(r',,'), ',')
              .replaceAll(RegExp(r'^, '), '');
          _isAddressSelected = true;
        });
      }
    } catch (e) {
      PrintUtil.error('Failed to get address: $e');
      setState(() {
        _address = 'unknown_address'.tr(context);
        _isAddressSelected = false;
      });
    }
  }

  void _loadMapStyle(GoogleMapController controller) {
    try {
      DefaultAssetBundle.of(context)
          .loadString("assets/map_styles/light.json")
          .then((style) {
        controller.setMapStyle(style);
        setState(() {
          _isMapLoaded = true;
        });
      }).catchError((error) {
        PrintUtil.error("Error loading map style: $error");
        setState(() {
          _isMapLoaded = true; // Still mark as loaded even if style fails
        });
      });
    } catch (e) {
      PrintUtil.error("Error loading map style: $e");
      setState(() {
        _isMapLoaded = true;
      });
    }
  }

  Future<void> _moveToCurrentLocation() async {
    final globalCubit = context.read<GlobalCubit>();
    final currentLat = globalCubit.currentLat;
    final currentLong = globalCubit.currentLong;

    final currentPosition = LatLng(currentLat, currentLong);

    try {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 17),
        ),
      );

      setState(() {
        _markerPosition = currentPosition;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('selectedLocation'),
            position: currentPosition,
            infoWindow: InfoWindow(title: 'current_location'.tr(context)),
          ),
        );
      });

      await _getAddressFromLatLng(currentPosition);
    } catch (e) {
      PrintUtil.error("Error moving to current location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _initialCameraPosition == null
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.primary,
            ))
          : Stack(
              children: [
                //! Map
                GoogleMap(
                  // markers: _markers,
                  initialCameraPosition: _initialCameraPosition!,
                  onMapCreated: (GoogleMapController controller) {
                    if (!_controller.isCompleted) {
                      _controller.complete(controller);
                      _loadMapStyle(controller);
                    }
                  },
                  buildingsEnabled: true,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  zoomControlsEnabled: false,
                  onCameraMove: (position) async {
                    setState(() {
                      _markerPosition = LatLng(
                          position.target.latitude, position.target.longitude);
                      _markers.clear();
                      _markers.add(
                        Marker(
                          markerId: const MarkerId('selectedLocation'),
                          position: LatLng(position.target.latitude,
                              position.target.longitude),
                          infoWindow: InfoWindow(
                              title: 'selected_location'.tr(context)),
                        ),
                      );
                    });
                    await _getAddressFromLatLng(LatLng(
                        position.target.latitude, position.target.longitude));
                  },
                ),

                // Loading indicator
                if (!_isMapLoaded)
                  Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Header with back button
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: CustomHeader(
                      showBackButton: true,
                      showLogo: true,
                      onBackPressed: () => Navigator.pop(context),
                      title: 'select_location_on_map'.tr(context),
                    ),
                  ),
                ),
                //! Marker
                Positioned(
                    child: Container(
                  margin: EdgeInsets.only(bottom: 40.h),
                  child: Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 50.sp,
                    ),
                  ),
                )),
                // Search field
                Positioned(
                  top: 100.h,
                  left: 20.w,
                  right: 20.w,
                  child: SingleChildScrollView(
                    child: LocationSearchField(
                      textController: _searchController,
                      onSuggestionSelected: (suggestion) async {
                        try {
                          final latLng =
                              LatLng(suggestion['lat']!, suggestion['lng']!);
                          final GoogleMapController controller =
                              await _controller.future;
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: latLng, zoom: 17),
                            ),
                          );
                          setState(() {
                            _markerPosition = latLng;
                            _markers.clear();
                            _markers.add(
                              Marker(
                                markerId: const MarkerId('selectedLocation'),
                                position: latLng,
                                infoWindow: InfoWindow(
                                    title: 'selected_location'.tr(context)),
                              ),
                            );
                          });
                          await _getAddressFromLatLng(latLng);
                        } catch (e) {
                          PrintUtil.error("Error selecting location: $e");
                        }
                      },
                      hintText: "search_for_location".tr(context),
                    ),
                  ),
                ),

                // Current location button
                Positioned(
                  top: 170.h,
                  right: isRTL ? null : 20.w,
                  left: isRTL ? 20.w : null,
                  child: FloatingActionButton(
                    heroTag: "currentLocationBtn",
                    backgroundColor: Colors.white,
                    mini: true,
                    onPressed: _moveToCurrentLocation,
                    child: const Icon(
                      Icons.my_location,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Address card and confirm button
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'selected_address'.tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.all(12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F9),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: AppColors.lightGrey,
                              width: 1.w,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.location_solid,
                                color: AppColors.primary,
                                size: 24.w,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  _address ?? 'unknown_address'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        AppButton(
                          onPressed: _isAddressSelected
                              ? () {
                                  if (_markerPosition != null) {
                                    Navigator.pop(
                                      context,
                                      {
                                        'lat': _markerPosition!.latitude,
                                        'lng': _markerPosition!.longitude,
                                        'address': _address,
                                      },
                                    );
                                  }
                                }
                              : null,
                          text: 'confirm_location'.tr(context),
                          height: 50.h,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    Key? key,
    required this.textController,
    required this.onSuggestionSelected,
    required this.hintText,
  }) : super(key: key);

  final TextEditingController textController;
  final String hintText;
  final void Function(Map<String, dynamic>) onSuggestionSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: textController,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: AppColors.primary,
                size: 20.w,
              ),
              suffixIcon: textController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        CupertinoIcons.clear,
                        color: Colors.grey,
                        size: 18.w,
                      ),
                      onPressed: () {
                        textController.clear();
                      },
                    )
                  : null,
              border: getBorderStyle(context),
              enabledBorder: getBorderStyle(context),
              errorBorder: getBorderStyle(context),
              focusedBorder: getBorderStyle(context),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              hintStyle: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.length < 3) return [];
            return await fetchSuggestions(pattern);
          },
          noItemsFoundBuilder: (context) {
            return Container(
              height: 50.h,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                'no_results_found'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            );
          },
          errorBuilder: (context, error) {
            String errorMessage;

            if (error is http.ClientException) {
              errorMessage = 'connection_error'.tr(context);
            } else {
              errorMessage = "something_went_wrong".tr(context);
            }

            PrintUtil.debug(error.toString());
            return Container(
              height: 50.h,
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                errorMessage,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                ),
              ),
            );
          },
          suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
            elevation: 4,
            constraints: BoxConstraints(
              maxHeight: 300.h,
            ),
          ),
          loadingBuilder: (context) {
            return Padding(
              padding: EdgeInsets.all(12.h),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
          keepSuggestionsOnLoading: false,
          hideOnEmpty: true,
          hideOnError: true,
          hideOnLoading: true,
          itemBuilder: (context, dynamic suggestion) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom:
                      BorderSide(color: AppColors.lightGrey.withOpacity(0.4)),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      color: AppColors.primary,
                      size: 20.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        suggestion['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          onSuggestionSelected: (dynamic suggestion) async {
            textController.text = suggestion['description'];
            final placeId = suggestion['place_id'];
            final Map<String, dynamic> location =
                await fetchPlaceDetails(placeId);
            location['description'] = suggestion['description'];
            PrintUtil.debug("$hintText $location");
            onSuggestionSelected(location);
          },
        ),
      ),
    );
  }

  OutlineInputBorder getBorderStyle(context) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(
        color: AppColors.lightGrey,
        width: 1.w,
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchSuggestions(String input) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=AIzaSyByGILjqDwyW9fMzjnXSCcPB11K8qboJEI&types=geocode&components=country:eg');
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        return List<Map<String, dynamic>>.from(json['predictions']);
      }
    } catch (e) {
      PrintUtil.error("Error fetching suggestions: $e");
    }
    return [];
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyByGILjqDwyW9fMzjnXSCcPB11K8qboJEI');
      final response = await http.get(url);
      final json = jsonDecode(response.body);
      if (json['status'] == 'OK') {
        final location = json['result']['geometry']['location'];
        return {'lat': location['lat'], 'lng': location['lng']};
      }
    } catch (e) {
      PrintUtil.error("Error fetching place details: $e");
    }
    return {'lat': 0.0, 'lng': 0.0};
  }
}
