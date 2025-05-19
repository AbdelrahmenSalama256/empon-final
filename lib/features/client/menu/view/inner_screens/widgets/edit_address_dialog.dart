import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../auth/data/models/user_data_model.dart';

class EditAddressDialog extends StatefulWidget {
  final Address address;
  final Function(Address) onSave;
  final VoidCallback onDelete;

  const EditAddressDialog({
    super.key,
    required this.address,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditAddressDialog> createState() => _EditAddressDialogState();
}

class _EditAddressDialogState extends State<EditAddressDialog> {
  late TextEditingController addressController;
  LocationModel? selectedCountry;
  LocationModel? selectedState;
  LocationModel? selectedCity;

  @override
  void initState() {
    super.initState();
    addressController =
        TextEditingController(text: widget.address.address ?? '');

    final cubit = context.read<RegisterCubit>();
    cubit.fetchAllLocations();

    // Set initial selections based on address IDs or names
    if (widget.address.countryId != null) {
      selectedCountry = cubit.allCountries.firstWhere(
        (country) => country.id == widget.address.countryId,
        orElse: () =>
            const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
      );
      if (selectedCountry?.id == 0) selectedCountry = null;
    } else if (widget.address.country != null) {
      selectedCountry = cubit.allCountries.firstWhere(
        (country) => country.name == widget.address.country,
        orElse: () =>
            const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
      );
      if (selectedCountry?.id == 0) selectedCountry = null;
    }

    if (widget.address.stateId != null && selectedCountry != null) {
      cubit.setCountry(selectedCountry!);
      selectedState = cubit.getFilteredStates().firstWhere(
            (state) => state.id == widget.address.stateId,
            orElse: () =>
                const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
          );
      if (selectedState?.id == 0) selectedState = null;
    } else if (widget.address.state != null && selectedCountry != null) {
      cubit.setCountry(selectedCountry!);
      selectedState = cubit.getFilteredStates().firstWhere(
            (state) => state.name == widget.address.state,
            orElse: () =>
                const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
          );
      if (selectedState?.id == 0) selectedState = null;
    }

    if (widget.address.cityId != null && selectedState != null) {
      cubit.setGovernorate(selectedState!);
      selectedCity = cubit.getFilteredCities().firstWhere(
            (city) => city.id == widget.address.cityId,
            orElse: () =>
                const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
          );
      if (selectedCity?.id == 0) selectedCity = null;
    } else if (widget.address.city != null && selectedState != null) {
      cubit.setGovernorate(selectedState!);
      selectedCity = cubit.getFilteredCities().firstWhere(
            (city) => city.name == widget.address.city,
            orElse: () =>
                const LocationModel(id: 0, name: '', countryId: 0, stateId: 0),
          );
      if (selectedCity?.id == 0) selectedCity = null;
    }
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is LocationsError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();
        List<LocationModel> countries = cubit.allCountries;
        List<LocationModel> states = cubit.getFilteredStates();
        List<LocationModel> cities = cubit.getFilteredCities();

        bool isLoading = state is LocationsLoading;

        return Dialog(
          insetPadding: EdgeInsets.all(16.w),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'edit_address'.tr(context),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'address_details'.tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: 'street_building_etc'.tr(context),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'location'.tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  AppDropdownField(
                    hint: 'country'.tr(context),
                    value: selectedCountry?.name,
                    items: countries.map((country) => country.name).toList(),
                    enabled: countries.isNotEmpty,
                    onChanged: (value) {
                      if (value == null) return;
                      final selected = countries.firstWhere(
                        (country) => country.name == value,
                        orElse: () => const LocationModel(
                            id: 0, name: '', countryId: 0, stateId: 0),
                      );
                      if (selected.id != 0) {
                        setState(() {
                          selectedCountry = selected;
                          selectedState = null;
                          selectedCity = null;
                        });
                        cubit.setCountry(selected);
                      }
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  ),
                  SizedBox(height: 16.h),
                  AppDropdownField(
                    hint: 'state'.tr(context),
                    value: selectedState?.name,
                    items: states.map((state) => state.name).toList(),
                    enabled: states.isNotEmpty,
                    onChanged: (value) {
                      if (value == null) return;
                      final selected = states.firstWhere(
                        (state) => state.name == value,
                        orElse: () => const LocationModel(
                            id: 0, name: '', countryId: 0, stateId: 0),
                      );
                      if (selected.id != 0) {
                        setState(() {
                          selectedState = selected;
                          selectedCity = null;
                        });
                        cubit.setGovernorate(selected);
                      }
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  ),
                  SizedBox(height: 16.h),
                  AppDropdownField(
                    hint: 'city'.tr(context),
                    value: selectedCity?.name,
                    items: cities.map((city) => city.name).toList(),
                    enabled: cities.isNotEmpty,
                    onChanged: (value) {
                      if (value == null) return;
                      final selected = cities.firstWhere(
                        (city) => city.name == value,
                        orElse: () => const LocationModel(
                            id: 0, name: '', countryId: 0, stateId: 0),
                      );
                      if (selected.id != 0) {
                        setState(() {
                          selectedCity = selected;
                        });
                        cubit.setCity(selected);
                      }
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  ),
                ],
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onPressed: widget.onDelete,
                        text: 'delete'.tr(context),
                        backgroundColor: AppColors.red,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppButton(
                        onPressed: () {
                          if (addressController.text.isEmpty ||
                              selectedCity == null) {
                            showToast(
                              context,
                              message: 'required_fields_missing'.tr(context),
                              state: ToastStates.error,
                            );
                            return;
                          }
                          final updatedAddress = widget.address.copyWith(
                            address: addressController.text,
                            cityId: selectedCity?.id,
                            stateId: selectedState?.id,
                            countryId: selectedCountry?.id,
                            city: selectedCity?.name,
                            state: selectedState?.name,
                            country: selectedCountry?.name,
                          );
                          widget.onSave(updatedAddress);
                          Navigator.pop(context);
                        },
                        text: 'save'.tr(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
