import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_dropdown.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/business_account_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CreateBusinessAccountDetailsPage extends StatefulWidget {
  const CreateBusinessAccountDetailsPage({super.key});

  @override
  State<CreateBusinessAccountDetailsPage> createState() =>
      _CreateBusinessAccountDetailsPageState();
}

class _CreateBusinessAccountDetailsPageState
    extends State<CreateBusinessAccountDetailsPage> {
  String? _selecteCategory;
  final List<String> _governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'أسيوط',
    'المنصورة'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'create_business_account'.tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
              style: HeaderStyle.standard,
            ),
            SizedBox(height: 24.h),
            //! Business account title and description
            Container(
              margin: EdgeInsets.all(10.w),
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: const Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'business_account_title'.tr(context),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Subtitle
                        Text(
                          'business_account_subtitle'.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.black,
                          ),
                        ),

                        SizedBox(height: 8.h),

                        // Description
                        Text(
                          'business_account_description'.tr(context),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: AppColors.black,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/images/svg/create_bussins.svg",
                    width: 106.w,
                    height: 116.h,
                  )
                ],
              ),
            ),
            // SizedBox(height: 16.h),
            // Business account name field
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),

                    // Business account name section
                    Text(
                      'business_account_name_question'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      'business_account_name_instructions'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7C7C7C),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    //! Business name field
                    AppDropdownField(
                      hint: 'category'.tr(context),
                      value: _selecteCategory,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(13.w),
                        child: SvgPicture.asset(
                          "assets/images/svg/category.svg",
                          width: 20.w,
                          height: 20.h,
                          fit: BoxFit.fill,
                        ),
                      ),
                      items: _governorates,
                      onChanged: (value) {
                        setState(() {
                          _selecteCategory = value;
                        });
                      },
                      // validator: (value) {
                      //   if (value == null) {
                      //     return 'Please select a governorate';
                      //   }
                      //   return null;
                      // },
                      showErrorBorder:
                          // _formKey.currentState?.validate() == false &&
                          _selecteCategory == null,
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      'precise_category_selection'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7C7C7C),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Subtitle
                    Text(
                      'add_new_category_hint'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff7C7C7C),
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Bottom buttons
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        children: [
                          AppButton(
                            text: 'create_business_account'.tr(context),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BusinessAccountSuccessPage(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
