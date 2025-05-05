import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewAddressPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;

  const AddNewAddressPage({
    super.key,
    required this.onNextStep,
    required this.onPreviousStep,
  });

  @override
  _AddNewAddressPageState createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  LocationModel? _selectedCountry;
  LocationModel? _selectedState;
  LocationModel? _selectedCity;

  @override
  void initState() {
    super.initState();
    // Initialize dropdown values from cubit
    final cubit = context.read<RegisterCubit>();
    cubit.fetchAllLocations();
    _selectedCountry = cubit.selectedCountry;
    _selectedState = cubit.selectedState;
    _selectedCity = cubit.selectedCity;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<RegisterCubit, RegisterState>(
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

          PrintUtil.info("Current state: $state");
          PrintUtil.info("Countries count: ${countries.length}");
          PrintUtil.info("States count: ${states.length}");
          PrintUtil.info("Cities count: ${cities.length}");

          bool isLoading = state is LocationsLoading;

          return SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: true,
                  showLogo: true,
                  onBackPressed: () => widget.onPreviousStep(),
                  title: 'register'.tr(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),
                          Center(
                            child: Image.asset(
                              'assets/images/name.png',
                              width: 326.w,
                              height: 180.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 32.h),
                          QuestionWidget(
                            question: 'add_address'.tr(context),
                            subtitle:
                                'please_write_detailed_address'.tr(context),
                          ),
                          SizedBox(height: 32.h),
                          if (isLoading)
                            const Center(child: CustomLoadingIndicator())
                          else ...[
                            AppDropdownField(
                              hint: 'country'.tr(context),
                              value: _selectedCountry?.name,
                              items: countries
                                  .map((country) => country.name)
                                  .toList(),
                              enabled: countries.isNotEmpty,
                              onChanged: (value) {
                                if (value == null) return;
                                final selected = countries.firstWhere(
                                  (country) => country.name == value,
                                  orElse: () => const LocationModel(
                                      id: 0,
                                      name: '',
                                      countryId: 0,
                                      stateId: 0),
                                );
                                if (selected.id != 0) {
                                  setState(() {
                                    _selectedCountry = selected;
                                    _selectedState = null;
                                    _selectedCity = null;
                                  });
                                  cubit.setCountry(selected);
                                  PrintUtil.info(
                                      "Selected country: ${selected.name} (ID: ${selected.id})");
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
                              enabled: states.isNotEmpty,
                              onChanged: (value) {
                                if (value == null) return;
                                final selected = states.firstWhere(
                                  (state) => state.name == value,
                                  orElse: () => const LocationModel(
                                      id: 0,
                                      name: '',
                                      countryId: 0,
                                      stateId: 0),
                                );
                                if (selected.id != 0) {
                                  setState(() {
                                    _selectedState = selected;
                                    _selectedCity = null;
                                  });
                                  cubit.setGovernorate(selected);
                                  PrintUtil.info(
                                      "Selected governorate: ${selected.name} (ID: ${selected.id})");
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
                              enabled: cities.isNotEmpty,
                              onChanged: (value) {
                                if (value == null) return;
                                final selected = cities.firstWhere(
                                  (city) => city.name == value,
                                  orElse: () => const LocationModel(
                                      id: 0,
                                      name: '',
                                      countryId: 0,
                                      stateId: 0),
                                );
                                if (selected.id != 0) {
                                  setState(() {
                                    _selectedCity = selected;
                                  });
                                  cubit.setCity(selected);
                                  PrintUtil.info(
                                      "Selected city: ${selected.name} (ID: ${selected.id})");
                                }
                              },
                              validator: (value) => value == null
                                  ? 'please_select_city'.tr(context)
                                  : null,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 16.w),
                            ),
                            SizedBox(height: 16.h),
                            AppTextField(
                              controller: cubit.detailedAddressController,
                              hintText: 'detailed_address'.tr(context),
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              validator: (value) => value!.isEmpty
                                  ? 'please_enter_detailed_address'.tr(context)
                                  : null,
                            ),
                            SizedBox(height: 16.h),
                            GestureDetector(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectLocationMapPage(),
                                  ),
                                );
                                if (result != null) {
                                  cubit.setLocation(
                                    result['address'],
                                    result['lat'].toString(),
                                    result['lng'].toString(),
                                  );
                                  setState(() {});
                                  PrintUtil.info(
                                      "Location selected: ${result['address']}, Lat: ${result['lat']}, Lng: ${result['lng']}");
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F2F9),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: cubit.lat == null
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
                                        cubit.detailedAddressController.text
                                                .isEmpty
                                            ? 'select_location'.tr(context)
                                            : cubit
                                                .detailedAddressController.text,
                                        maxLines: 1,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 16.sp,
                                          color: cubit.detailedAddressController
                                                  .text.isEmpty
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
                              isLoading: state is RegisterLoading,
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    cubit.lat != null &&
                                    cubit.lng != null) {
                                  PrintUtil.info(
                                      "Navigating to next step with data: "
                                      "Country: ${_selectedCountry?.name} (ID: ${_selectedCountry?.id}), "
                                      "Governorate: ${_selectedState?.name} (ID: ${_selectedState?.id}), "
                                      "City: ${_selectedCity?.name} (ID: ${_selectedCity?.id}), "
                                      "Detailed Address: ${cubit.detailedAddressController.text}, "
                                      "Lat: ${cubit.lat}, Lng: ${cubit.lng}");
                                  widget.onNextStep();
                                } else {
                                  showToast(
                                    context,
                                    message: cubit.lat == null
                                        ? 'please_select_location'.tr(context)
                                        : 'please_fill_all_fields'.tr(context),
                                    state: ToastStates.error,
                                  );
                                }
                              },
                              height: 50.h,
                              width: double.infinity,
                            ),
                          ],
                          SizedBox(height: 16.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
