import 'package:embone/core/component/custom_header.dart';
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
import 'package:embone/features/client/profile/view/pages/add_profile_photo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';

class AddNewAddressPage extends StatefulWidget {
  const AddNewAddressPage({super.key});

  @override
  State<AddNewAddressPage> createState() => _AddNewAddressPageState();
}

class _AddNewAddressPageState extends State<AddNewAddressPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: true,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'register'.tr(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Form(
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
                          AppDropdownField(
                            hint: 'country'.tr(context),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            value: cubit.country,
                            items: cubit.countryIdMap.keys.toList(),
                            onChanged: (value) {
                              PrintUtil.info("Selected country: $value");
                              cubit.setCountry(value);
                              setState(() {});
                            },
                            showErrorBorder: cubit.country == null,
                          ),
                          SizedBox(height: 16.h),
                          AppDropdownField(
                            hint: 'governorate'.tr(context),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            value: cubit.governorate,
                            items: cubit.governorateIdMap.keys.toList(),
                            onChanged: (value) {
                              PrintUtil.info("Selected governorate: $value");
                              cubit.setGovernorate(value);
                              setState(() {});
                            },
                            showErrorBorder: cubit.governorate == null,
                          ),
                          SizedBox(height: 16.h),
                          AppTextField(
                            controller: cubit.cityAreaController,
                            hintText: 'city_area'.tr(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 16.h),
                          AppTextField(
                            controller: cubit.detailedAddressController,
                            hintText: 'detailed_address'.tr(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 16.h),
                          InkWell(
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
                            isLoading: false,
                            onPressed: () {
                              if (cubit.country != null &&
                                  cubit.country!.isNotEmpty &&
                                  cubit.governorate != null &&
                                  cubit.governorate!.isNotEmpty &&
                                  cubit.cityAreaController.text.isNotEmpty &&
                                  cubit.detailedAddressController.text
                                      .isNotEmpty &&
                                  cubit.lat != null &&
                                  cubit.lng != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: cubit,
                                      child: const AddProfilePhotoPage(),
                                    ),
                                  ),
                                );
                                PrintUtil.info(
                                    "Navigating to AddProfilePhotoPage with data: "
                                    "Country: ${cubit.country}, "
                                    "Governorate: ${cubit.governorate}, "
                                    "City/Area: ${cubit.cityAreaController.text}, "
                                    "Detailed Address: ${cubit.detailedAddressController.text}, "
                                    "Lat: ${cubit.lat}, Lng: ${cubit.lng}");
                              }
                            },
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
      },
    );
  }
}
