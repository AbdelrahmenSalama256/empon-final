import 'package:embone/core/component/widgets/app_dropdown_form_field.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactInfoStep extends StatefulWidget {
  const ContactInfoStep({super.key});

  @override
  State<ContactInfoStep> createState() => _ContactInfoStepState();
}

class _ContactInfoStepState extends State<ContactInfoStep> {
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  String? _selectedCountry;
  String? _selectedGovernorate;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _websiteController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactSection(context),
              SizedBox(height: 30.h),
              _buildLocationSection(context),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'contact_information'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _websiteController,
          labelText: 'website'.tr(context),
          hintText: 'enter_website'.tr(context),
          prefixIcon: Padding(
            padding: EdgeInsets.all(13.w),
            child: SvgPicture.asset("assets/images/svg/www.svg", width: 20.w),
          ),
          validator: (value) => Validators.validateRequired(
              value, 'website'.tr(context), context),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _emailController,
          labelText: 'email'.tr(context),
          hintText: 'enter_email'.tr(context),
          prefixIcon: Icon(
            CupertinoIcons.envelope,
            size: 20.sp,
            color: const Color(0xff8F95AB),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) => Validators.validateEmail(value, context),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _phoneController,
          labelText: 'phone_number'.tr(context),
          hintText: 'enter_phone'.tr(context),
          prefixIcon: Icon(
            CupertinoIcons.phone,
            size: 20.sp,
            color: const Color(0xff8F95AB),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) => Validators.validatePhone(value, context),
        ),
      ],
    );
  }

  Widget _buildLocationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'location'.tr(context),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 16.h),
        AppDropdownFormField(
          hint: 'country'.tr(context),
          items: const ['السعودية', 'مصر', 'الإمارات', 'الكويت'],
          initialValue: _selectedCountry,
          validator: (value) => value == null || value.isEmpty
              ? 'field_required'.tr(context)
              : null,
          onSaved: (value) => _selectedCountry = value,
        ),
        SizedBox(height: 16.h),
        AppDropdownFormField(
          hint: 'governorate'.tr(context),
          items: const ['الرياض', 'جدة', 'الدمام', 'مكة'],
          initialValue: _selectedGovernorate,
          validator: (value) => value == null || value.isEmpty
              ? 'field_required'.tr(context)
              : null,
          onSaved: (value) => _selectedGovernorate = value,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _addressController,
          labelText: 'address'.tr(context),
          hintText: 'enter_address'.tr(context),
          prefixIcon: Icon(
            CupertinoIcons.location_solid,
            size: 20.sp,
            color: const Color(0xff8F95AB),
          ),
          validator: (value) => Validators.validateRequired(
              value, 'address'.tr(context), context),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _cityController,
          labelText: 'city_region'.tr(context),
          hintText: 'enter_city_region'.tr(context),
          validator: (value) => Validators.validateRequired(
              value, 'city_region'.tr(context), context),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: _postalCodeController,
          labelText: 'postal_code'.tr(context),
          hintText: 'enter_postal_code'.tr(context),
          keyboardType: TextInputType.number,
          validator: (value) => Validators.validateRequired(
              value, 'postal_code'.tr(context), context),
        ),
      ],
    );
  }
}
