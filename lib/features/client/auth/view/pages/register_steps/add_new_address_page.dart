import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:embone/features/client/menu/view/inner_screens/addresses_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddNewAddressPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  final String? type;

  const AddNewAddressPage({
    super.key,
    required this.onNextStep,
    required this.onPreviousStep,
    this.type,
  });

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<RegisterCubit>();
    cubit.fetchAllLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocProvider(
        create: (context) => GlobalCubit(),
        child: BlocListener<GlobalCubit, GlobalState>(
          listener: (context, globalState) {
            if (globalState is AddressError) {
              showToast(context,
                  message: globalState.message, state: ToastStates.error);
            }
            if (globalState is AddressSuccess) {
              showToast(context,
                  message: "address_updated_successfully".tr(context),
                  state: ToastStates.success);
              Navigator.pop(context);
              navigateReplac(context, const AddressesScreen());
            }
          },
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is LocationsError) {
                showToast(
                  context,
                  message: 'unexpected_error'.tr(context),
                  state: ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              final globalCubit = context.read<GlobalCubit>();
              final cubit = context.read<RegisterCubit>();

              // Get the current state values from cubit
              final selectedCountry = cubit.selectedCountry;
              final selectedState = cubit.selectedState;
              final selectedCity = cubit.selectedCity;

              // Get the filtered lists from cubit
              final countries = cubit.allCountries;
              final states = cubit.getFilteredStates();
              final cities = cubit.getFilteredCities();

              bool isLoading = state is LocationsLoading;

              return SafeArea(
                child: Column(
                  children: [
                    widget.type != "profile"
                        ? CustomHeader(
                            showBackButton: true,
                            showLogo: true,
                            onBackPressed: () => widget.onPreviousStep(),
                            title: 'register'.tr(context),
                          )
                        : AppHeader(
                            title: "add_location".tr(context),
                            onBackPressed: () => widget.onPreviousStep(),
                            centerTitle: true,
                          ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              Center(
                                child: Image.asset(
                                  widget.type != "profile"
                                      ? 'assets/images/name.png'
                                      : 'assets/images/add_address.png',
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
                                  value: selectedCountry?.name,
                                  items: countries
                                      .map((country) => country.name)
                                      .toList(),
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
                                  value: selectedState?.name,
                                  items: states
                                      .map((state) => state.name)
                                      .toList(),
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
                                  value: selectedCity?.name,
                                  items:
                                      cities.map((city) => city.name).toList(),
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
                                      setState(() {
                                        cubit.detailedAddressController.text =
                                            result['address'];
                                      });
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
                                                    .detailedAddressController
                                                    .text,
                                            maxLines: 1,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 16.sp,
                                              color: cubit
                                                      .detailedAddressController
                                                      .text
                                                      .isEmpty
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
                                  onPressed: widget.type == "profile"
                                      ? () {
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              cubit.lat != null &&
                                              cubit.lng != null) {
                                            PrintUtil.info(
                                                "Navigating to next step with data: "
                                                "Country: ${selectedCountry?.name} (ID: ${selectedCountry?.id}), "
                                                "Governorate: ${selectedState?.name} (ID: ${selectedState?.id}), "
                                                "City: ${selectedCity?.name} (ID: ${selectedCity?.id}), "
                                                "Detailed Address: ${cubit.detailedAddressController.text}, "
                                                "Lat: ${cubit.lat}, Lng: ${cubit.lng}");
                                            globalCubit.addAddress(
                                                address: cubit
                                                    .detailedAddressController
                                                    .text,
                                                city: selectedCity?.id
                                                        .toString() ??
                                                    "0",
                                                lat: cubit.lat ?? "",
                                                lng: cubit.lng ?? "");
                                          } else {
                                            showToast(
                                              context,
                                              message: cubit.lat == null
                                                  ? 'please_select_location'
                                                      .tr(context)
                                                  : 'please_fill_all_fields'
                                                      .tr(context),
                                              state: ToastStates.error,
                                            );
                                          }
                                        }
                                      : () {
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              cubit.lat != null &&
                                              cubit.lng != null) {
                                            PrintUtil.info(
                                                "Navigating to next step with data: "
                                                "Country: ${selectedCountry?.name} (ID: ${selectedCountry?.id}), "
                                                "Governorate: ${selectedState?.name} (ID: ${selectedState?.id}), "
                                                "City: ${selectedCity?.name} (ID: ${selectedCity?.id}), "
                                                "Detailed Address: ${cubit.detailedAddressController.text}, "
                                                "Lat: ${cubit.lat}, Lng: ${cubit.lng}");
                                            widget.onNextStep();
                                          } else {
                                            showToast(
                                              context,
                                              message: cubit.lat == null
                                                  ? 'please_select_location'
                                                      .tr(context)
                                                  : 'please_fill_all_fields'
                                                      .tr(context),
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
        ),
      ),
    );
  }
}
