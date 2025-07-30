import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/account_state.dart';

class BusinessAccountSettings extends StatefulWidget {
  final bool isUpdate;

  const BusinessAccountSettings({super.key, required this.isUpdate});

  @override
  _BusinessAccountSettingsState createState() =>
      _BusinessAccountSettingsState();
}

class _BusinessAccountSettingsState extends State<BusinessAccountSettings> {
  final _formKey = GlobalKey<FormState>();
  LocationModel? _selectedCountry;
  LocationModel? _selectedState;
  LocationModel? _selectedCity;
  int? _selectedCityId;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is AccountError) {
          showToast(
            context,
            message: 'unexpected_error'.tr(context),
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<AccountCubit>();
        _selectedCountry = cubit.selectedCountry;
        _selectedState = cubit.selectedState;
        _selectedCity = cubit.selectedCity;
        _selectedCityId = cubit.cityId;
        // Ensure cubit is initialized
        List<LocationModel> countries = cubit.allCountries;
        List<LocationModel> states = cubit.getFilteredStates();
        List<LocationModel> cities = cubit.getFilteredCities();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionWidget(
                  question: "complete_business_setup".tr(context),
                  subtitle: "business_setup_message".tr(context),
                  padding: EdgeInsets.symmetric(horizontal: 0.w),
                ),
                SizedBox(height: 20.h),
                Text(
                  'general'.tr(context),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: 10.h),
                AppTextField(
                  controller: cubit.descriptionController,
                  hintText: 'write_here'.tr(context),
                  maxLines: 5,
                  contentPadding: EdgeInsets.all(16.w),
                  validator: (value) => value!.isEmpty
                      ? 'please_enter_description'.tr(context)
                      : null,
                ),
                SizedBox(height: 5.h),
                widget.isUpdate
                    ? Text(
                        'business_description_hint'.tr(context),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff7C7C7C),
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: 16.h),
                _buildVideoUploadSection(context, cubit.videoUrlController),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'are_you_online_store'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CupertinoSwitch(
                      value: cubit.isVendorLocationEnabled,
                      onChanged: (value) {
                        cubit.toggleVendorLocation(value);
                      },
                      activeTrackColor: Colors.green,
                    ),
                  ],
                ),
                Visibility(
                  visible: !cubit.isVendorLocationEnabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        'vendor_location'.tr(context),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (state is LocationsLoading == true) ...{
                        const Center(child: CustomLoadingIndicator())
                      } else ...[
                        AppDropdownField(
                          hint: cubit.country ?? 'country'.tr(context),
                          value: _selectedCountry?.name ??
                              (cubit.country != null
                                  ? (countries
                                          .firstWhere(
                                              (country) =>
                                                  country.name == cubit.country,
                                              orElse: () => const LocationModel(
                                                  id: 0,
                                                  name: '',
                                                  countryId: 0,
                                                  stateId: 0))
                                          .name
                                          .isNotEmpty
                                      ? countries
                                          .firstWhere((country) =>
                                              country.name == cubit.country)
                                          .name
                                      : null)
                                  : null),
                          items:
                              countries.map((country) => country.name).toList(),
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
                          hint: cubit.stat ?? 'governorate'.tr(context),
                          value: _selectedState?.name ??
                              (cubit.stat != null
                                  ? (states
                                          .firstWhere(
                                              (state) =>
                                                  state.name == cubit.stat,
                                              orElse: () => const LocationModel(
                                                  id: 0,
                                                  name: '',
                                                  countryId: 0,
                                                  stateId: 0))
                                          .name
                                          .isNotEmpty
                                      ? states
                                          .firstWhere((state) =>
                                              state.name == cubit.stat)
                                          .name
                                      : null)
                                  : null),
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
                          hint: cubit.city ?? 'city'.tr(context),
                          value: _selectedCity?.name ??
                              (cubit.city != null
                                  ? (cities
                                          .firstWhere(
                                              (city) => city.name == cubit.city,
                                              orElse: () => const LocationModel(
                                                  id: 0,
                                                  name: '',
                                                  countryId: 0,
                                                  stateId: 0))
                                          .name
                                          .isNotEmpty
                                      ? cities
                                          .firstWhere(
                                              (city) => city.id == cubit.cityId)
                                          .name
                                      : null)
                                  : null),
                          items: cities.map((city) => city.name).toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            final selected = cities.firstWhere(
                              (city) => city.name == value,
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
                        AppTextField(
                          controller: cubit.addressController,
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
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F9),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: cubit.latController.text.isEmpty
                                    ? Colors.red
                                    : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    cubit.addressController.text.isEmpty
                                        ? 'select_location'.tr(context)
                                        : cubit.addressController.text,
                                    maxLines: 1,
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16.sp,
                                      color:
                                          cubit.addressController.text.isEmpty
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
                        SizedBox(height: 16.h),
                        AppTextField(
                          controller: cubit.postalCodeController,
                          labelText: 'postal_code'.tr(context),
                          hintText: 'enter_postal_code'.tr(context),
                          keyboardType: TextInputType.number,
                          validator: (value) => Validators.validateRequired(
                              value, 'postal_code'.tr(context), context),
                        ),
                        SizedBox(height: 32.h),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVideoUploadSection(
      BuildContext context, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'add_video'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 5.h),
        Text(
          'video_upload_subtitle'.tr(context),
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff7C7C7C),
          ),
        ),
        SizedBox(height: 10.h),
        AppTextField(
          controller: controller,
          hintText: 'video_url_placeholder'.tr(context),
          contentPadding: EdgeInsets.all(16.w),
          validator: (value) =>
              value!.isEmpty ? 'please_enter_video_url'.tr(context) : null,
        ),
      ],
    );
  }
}
