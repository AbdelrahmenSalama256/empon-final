import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/profile/view/pages/add_profile_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class AddNewAddressPage extends StatefulWidget {
  final String firstName;
  final String phoneNumber;
  final String password;
  final DateTime dateOfBirth;
  final Gender gender;

  const AddNewAddressPage({
    super.key,
    required this.firstName,
    required this.phoneNumber,
    required this.password,
    required this.dateOfBirth,
    required this.gender,
  });

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _cityAreaController = TextEditingController();
  final _detailedAddressController = TextEditingController();
  bool _isLoading = false;

  // Dropdown values
  String? _selectedCountry;
  String? _selectedGovernorate;

  // Sample data for dropdowns
  final List<String> _countries = [
    'مصر',
    'السعودية',
    'الإمارات',
    'الكويت',
    'قطر'
  ];
  final List<String> _governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'أسيوط',
    'المنصورة'
  ];

  //! Location data
  String? _selectedAddress;

  @override
  void dispose() {
    _cityAreaController.dispose();
    _detailedAddressController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate() &&
        _selectedCountry != null &&
        _selectedGovernorate != null) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddProfilePhotoPage(
              firstName: widget.firstName,
              dateOfBirth: widget.dateOfBirth,
              gender: widget.gender,
              phoneNumber: widget.phoneNumber,
              password: widget.password,
              selectedLocation: _selectedAddress ?? "unknown".tr(context),
            ),
          ),
        );
        PrintUtil.info("Navigating to AddProfilePhotoPage with data: "
            "First Name: ${widget.firstName}, "
            "Date of Birth: ${widget.dateOfBirth}, "
            "Gender: ${widget.gender}, "
            "Phone Number: ${widget.phoneNumber}, "
            "Password: ${widget.password}, "
            "Selected Location: ${_selectedAddress ?? "unknown".tr(context)}");
      });
    } else {
      // Show validation errors
      setState(() {});
    }
  }

  void _selectLocation() async {
    // Open MapSearchPage as a popup
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SelectLocationMapPage(),
      ),
    );

    // Handle the result from MapSearchPage
    if (result != null) {
      setState(() {
        _selectedAddress = result['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            CustomHeader(
              showBackButton: true,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),

                      // Image Section
                      Center(
                        child: Image.asset(
                          'assets/images/name.png',
                          width: 326.w,
                          height: 180.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Question Section
                      QuestionWidget(
                        question: 'add_address'.tr(context),
                        subtitle: 'please_write_detailed_address'.tr(context),
                      ),
                      SizedBox(height: 32.h),

                      // Country Dropdown
                      AppDropdownField(
                        hint: 'country'.tr(context),
                        value: _selectedCountry,
                        items: _countries,
                        onChanged: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a country';
                          }
                          return null;
                        },
                        showErrorBorder:
                            _formKey.currentState?.validate() == false &&
                                _selectedCountry == null,
                      ),

                      SizedBox(height: 16.h),

                      // Governorate Dropdown
                      AppDropdownField(
                        hint: 'governorate'.tr(context),
                        value: _selectedGovernorate,
                        items: _governorates,
                        onChanged: (value) {
                          setState(() {
                            _selectedGovernorate = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a governorate';
                          }
                          return null;
                        },
                        showErrorBorder:
                            _formKey.currentState?.validate() == false &&
                                _selectedGovernorate == null,
                      ),

                      SizedBox(height: 16.h),

                      // City/Area Input
                      AppTextField(
                        controller: _cityAreaController,
                        hintText: 'city_area'.tr(context),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) => Validators.validateRequired(
                            value, 'city_area'.tr(context), context),
                      ),
                      SizedBox(height: 16.h),

                      // Detailed Address Input
                      AppTextField(
                        controller: _detailedAddressController,
                        hintText: 'detailed_address'.tr(context),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        validator: (value) => Validators.validateRequired(
                            value, 'detailed_address'.tr(context), context),
                      ),
                      SizedBox(height: 16.h),

                      // Location Selector
                      InkWell(
                        onTap: _selectLocation,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F9),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  _selectedAddress ??
                                      'select_location'.tr(context),
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 16.sp,
                                    color: _selectedAddress == null
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
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

                      // Button Section
                      AppButton(
                        text: 'confirm_address'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _continue,
                        height: 50.h,
                        width: double.infinity,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
