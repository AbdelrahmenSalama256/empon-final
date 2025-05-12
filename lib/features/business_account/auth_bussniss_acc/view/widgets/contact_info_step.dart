// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:embone/core/component/widgets/app_dropdown_form_field.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';

class ContactInfoStep extends StatelessWidget {
  final AccountCubit cubit;
  const ContactInfoStep({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Form(
          key: GlobalKey<FormState>(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildContactSection(context, cubit),
              SizedBox(height: 30.h),
              _buildLocationSection(context, cubit),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, AccountCubit cubit) {
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
          controller: cubit.websiteController,
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
          controller: cubit.emailController,
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
          controller: cubit.phoneController,
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

  Widget _buildLocationSection(BuildContext context, AccountCubit cubit) {
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
          hint: 'city_region'.tr(context),
          items: cubit.cityIdMap.keys.toList(),
          initialValue: cubit.cityIdMap.entries
              .firstWhere((e) => e.value == cubit.selectedCityId,
                  orElse: () => const MapEntry('', ''))
              .key,
          validator: (value) => value == null || value.isEmpty
              ? 'field_required'.tr(context)
              : null,
          onSaved: (value) => cubit.updateCityId(value),
        ),
        SizedBox(height: 16.h),
        AppTextField(
          controller: cubit.addressController,
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
          controller: cubit.postalCodeController,
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
