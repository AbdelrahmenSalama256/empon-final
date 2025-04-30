import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/select_locaiton_map.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeAddressSheet extends StatefulWidget {
  const ChangeAddressSheet({super.key});

  @override
  State<ChangeAddressSheet> createState() => _ChangeAddressSheetState();
}

class _ChangeAddressSheetState extends State<ChangeAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cityAreaController = TextEditingController();
  final _detailedAddressController = TextEditingController();
  // Dropdown values
  String? _selectedCountry;
  String? _selectedGovernorate;
  bool _isLoading = false;

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

        Navigator.pop(context, true);
      });
    } else {
      // Show validation errors
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SingleChildScrollView(
        // padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Header Title
              Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: const Color(0xffDB3022),
                    size: 20.sp,
                  ),
                  Text(
                    'new_address'.tr(context),
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color(0xff6C7278),
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Country Dropdown
              _buildDropdownField(
                hint: 'country'.tr(context),
                value: _selectedCountry,
                items: _countries,
                onChanged: (value) {
                  setState(() {
                    _selectedCountry = value;
                  });
                },
              ),
              SizedBox(height: 16.h),

              // Governorate Dropdown
              _buildDropdownField(
                hint: 'governorate'.tr(context),
                value: _selectedGovernorate,
                items: _governorates,
                onChanged: (value) {
                  setState(() {
                    _selectedGovernorate = value;
                  });
                },
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
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _selectedAddress ?? 'select_location'.tr(context),
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
              SizedBox(height: 32.h.h),

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
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return InkWell(
      onTap: () {
        _showDropdownBottomSheet(
          context: context,
          title: hint,
          items: items,
          selectedValue: value,
          onChanged: onChanged,
        );
      },
      child: Container(
        // height: 48.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w, // Responsive horizontal padding
          vertical: 16.h, // Responsive vertical padding
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F9),
          borderRadius: BorderRadius.circular(15.r),
          border: value == null && _formKey.currentState?.validate() == false
              ? Border.all(color: Colors.red, width: 1.0)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hint,
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.black87,
                fontSize: 16.sp,
              ),
            ),
            Container(
              width: 25.w,
              height: 25.h,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDropdownBottomSheet({
    required BuildContext context,
    required String title,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(item),
                    trailing: selectedValue == item
                        ? const Icon(Icons.check, color: AppColors.primary)
                        : null,
                    onTap: () {
                      onChanged(item);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
