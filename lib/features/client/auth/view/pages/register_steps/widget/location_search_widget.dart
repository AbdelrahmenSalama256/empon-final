import 'dart:convert';

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class LocationSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(LatLng) onSuggestionSelected;

  const LocationSearchWidget({
    super.key,
    required this.controller,
    required this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: LocationSearchField(
        textController: controller,
        onSuggestionSelected: (suggestion) {
          final latLng = LatLng(suggestion['lat']!, suggestion['lng']!);
          onSuggestionSelected(latLng);
        },
        hintText: "search_for_location".tr(context),
      ),
    );
  }
}

class LocationSearchField extends StatelessWidget {
  const LocationSearchField({
    super.key,
    required this.textController,
    required this.onSuggestionSelected,
    required this.hintText,
  });

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
                      // ignore: deprecated_member_use
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
