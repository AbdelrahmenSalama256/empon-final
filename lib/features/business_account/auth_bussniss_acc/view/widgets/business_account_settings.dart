import 'package:dotted_border/dotted_border.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessAccountSettings extends StatefulWidget {
  const BusinessAccountSettings({
    super.key,
  });

  @override
  State<BusinessAccountSettings> createState() =>
      _BusinessAccountSettingsState();
}

class _BusinessAccountSettingsState extends State<BusinessAccountSettings> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionWidget(
            question: "complete_business_setup".tr(context),
            subtitle: "business_setup_message".tr(context),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'general'.tr(context),
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black),
                ),
                SizedBox(height: 10.h),
                AppTextField(
                  controller: TextEditingController(),
                  hintText: 'write_here'.tr(context),
                  maxLines: 5,
                  contentPadding: EdgeInsets.all(16.w),
                ),
                SizedBox(height: 5.h),
                Text(
                  'business_description_hint'.tr(context),
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff7C7C7C)),
                ),
                SizedBox(height: 16.h),
                _buildMediaUploadSection(context),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaUploadSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            'add_product_image'.tr(context),
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.black),
          ),
        ]),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () {},
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(15.r),
            strokeWidth: 1.w,
            dashPattern: const [9, 2],
            color: const Color(0xff8F95AB),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffF0F2F9),
                borderRadius: BorderRadius.circular(15.r),
              ),
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 8.w),
                  Icon(CupertinoIcons.cloud_upload,
                      color: const Color(0xff8F95AB), size: 24.sp),
                  SizedBox(width: 8.w),
                  Text('product_image_placeholder'.tr(context),
                      style: TextStyle(
                          fontSize: 14.sp, color: const Color(0xff8F95AB))),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'add_video'.tr(context),
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.black),
        ),
        SizedBox(height: 5.h),
        Text(
          'video_upload_subtitle'.tr(context),
          style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff7C7C7C)),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: () {},
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(15.r),
            strokeWidth: 2.w,
            dashPattern: const [8, 3],
            color: const Color.fromARGB(255, 173, 177, 190),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(166, 247, 248, 251),
                borderRadius: BorderRadius.circular(15.r),
              ),
              height: 100.h,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92.w,
                      height: 40.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE6F0FF),
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                      ),
                      child: Icon(Icons.file_upload_outlined,
                          color: AppColors.primary, size: 24.sp),
                    ),
                    SizedBox(height: 8.h),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'click_here'.tr(context),
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily:
                                context.read<GlobalCubit>().language == "ar"
                                    ? 'Beiruti'
                                    : "Poppins",
                            color: AppColors.primary,
                            fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: 'to_upload_your_video'.tr(context),
                        style: TextStyle(
                            fontFamily:
                                context.read<GlobalCubit>().language == "ar"
                                    ? 'Beiruti'
                                    : "Poppins",
                            fontSize: 14.sp,
                            color: const Color(0xff8F95AB),
                            fontWeight: FontWeight.w400),
                      ),
                    ])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
