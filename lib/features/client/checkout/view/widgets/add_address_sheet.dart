import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddAddressSheet extends StatefulWidget {
  final Function(Address) onAddressAdded;
  final GlobalCubit globalCubit;
  final RegisterCubit registerCubit;

  const AddAddressSheet({
    super.key,
    required this.onAddressAdded,
    required this.globalCubit,
    required this.registerCubit,
  });

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  LocationModel? _selectedCountry;
  LocationModel? _selectedState;
  LocationModel? _selectedCity;
  String? _detailedAddress;
  String? _lat;
  String? _lng;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<RegisterCubit>().fetchAllLocations();
  }

  void _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocationMapPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _detailedAddress = result['address'];
        _lat = result['lat'].toString();
        _lng = result['lng'].toString();
      });
    }
  }

  void _submitAddress() {
    if (_formKey.currentState!.validate() &&
        _lat != null &&
        _lng != null &&
        _selectedCity != null) {
      setState(() {
        _isLoading = true;
      });

      final newAddress = Address(
        country: _selectedCountry?.name,
        state: _selectedState?.name,
        city: _selectedCity?.name,
        cityId: _selectedCity?.id,
        address: _detailedAddress,
        lat: _lat,
        lng: _lng,
      );

      setState(() {
        _isLoading = true;
      });

      context.read<GlobalCubit>().addAddress(
            address: newAddress.address ?? "",
            city: newAddress.cityId.toString(),
            lat: newAddress.lat ?? "",
            lng: newAddress.lng ?? "",
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.globalCubit,
      child: BlocListener<GlobalCubit, GlobalState>(
        listener: (context, state) {
          if (state is AddressSuccess) {
            setState(() {
              _isLoading = false;
            });
            showToast(
              context,
              message: 'address_added_successfully'.tr(context),
              state: ToastStates.success,
            );
            Navigator.pop(context, true);
          } else if (state is AddressError) {
            setState(() {
              _isLoading = false;
            });
            showToast(
              context,
              message: 'error_adding_address'.tr(context),
              state: ToastStates.error,
            );
          }
        },
        child: BlocProvider.value(
          value: widget.registerCubit,
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is LocationsError) {
                showToast(
                  context,
                  message: state.message,
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              final cubit = context.read<RegisterCubit>();
              List<LocationModel> countries =
                  state is CountriesLoaded ? state.countries : [];
              List<LocationModel> states = cubit.getFilteredStates();
              List<LocationModel> cities = cubit.getFilteredCities();

              bool isLoading = state is LocationsLoading;

              return Padding(
                padding: EdgeInsets.all(16.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              color: const Color(0xffDB3022),
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'add_address'.tr(context),
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: const Color(0xff6C7278),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        if (isLoading)
                          const Center(child: CircularProgressIndicator())
                        else ...[
                          AppDropdownField(
                            hint: 'country'.tr(context),
                            value: _selectedCountry?.name,
                            items: countries
                                .map((country) => country.name)
                                .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final selected = countries.firstWhere(
                                (country) => country.name == value,
                                orElse: () => const LocationModel(
                                    id: 0, name: '', countryId: 0, stateId: 0),
                              );
                              if (selected.id != 0) {
                                setState(() {
                                  _selectedCountry = selected;
                                  _selectedState = null;
                                  _selectedCity = null;
                                });
                                cubit.setCountry(selected);
                              }
                            },
                            validator: (value) => value == null
                                ? 'please_select_country'.tr(context)
                                : null,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                          ),
                          SizedBox(height: 16.h),
                          AppDropdownField(
                            hint: 'governorate'.tr(context),
                            value: _selectedState?.name,
                            items: states.map((state) => state.name).toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final selected = states.firstWhere(
                                (state) => state.name == value,
                                orElse: () => const LocationModel(
                                    id: 0, name: '', countryId: 0, stateId: 0),
                              );
                              if (selected.id != 0) {
                                setState(() {
                                  _selectedState = selected;
                                  _selectedCity = null;
                                });
                                cubit.setGovernorate(selected);
                              }
                            },
                            validator: (value) => value == null
                                ? 'please_select_governorate'.tr(context)
                                : null,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                          ),
                          SizedBox(height: 16.h),
                          AppDropdownField(
                            hint: 'city'.tr(context),
                            value: _selectedCity?.name,
                            items: cities.map((city) => city.name).toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final selected = cities.firstWhere(
                                (city) => city.name == value,
                                orElse: () => const LocationModel(
                                    id: 0, name: '', countryId: 0, stateId: 0),
                              );
                              if (selected.id != 0) {
                                setState(() {
                                  _selectedCity = selected;
                                });
                                cubit.setCity(selected);
                              }
                            },
                            validator: (value) => value == null
                                ? 'please_select_city'.tr(context)
                                : null,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: _selectLocation,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F9),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: _lat == null
                                      ? Colors.red
                                      : Colors.transparent,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _detailedAddress ??
                                          'select_location'.tr(context),
                                      maxLines: 1,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16.sp,
                                        color: _detailedAddress == null
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Icon(
                                    CupertinoIcons.location_fill,
                                    color: Colors.grey,
                                    size: 24.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          AppButton(
                            text: 'confirm_address'.tr(context),
                            isLoading: _isLoading,
                            onPressed: _submitAddress,
                            height: 50.h,
                            width: double.infinity,
                          ),
                          SizedBox(height: 16.h),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
