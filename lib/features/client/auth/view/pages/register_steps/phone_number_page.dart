import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberPage extends StatefulWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const PhoneNumberPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return BlocBuilder(
      bloc: cubit,
      builder: (context, state) {
        return BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is VerifyPhoneNumberError) {
              showToast(context,
                  message: state.error, state: ToastStates.error);
            }
            if (state is VerifyPhoneNumberSuccess) {
              PrintUtil.success('Phone number verified successfully');
              showToast(context,
                  message: state.message, state: ToastStates.success);
              widget.onNextStep();
            }
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppStepIndicator(
                                currentStep: 4, totalSteps: 8),
                            SizedBox(height: 16.h),
                            Center(
                              child: Image.asset(
                                'assets/images/name.png',
                                width: 326.w,
                                height: 244.h,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 32.h),
                            QuestionWidget(
                              question: 'what_phone_number'.tr(context),
                              subtitle: 'phone_number_description'.tr(context),
                            ),
                            SizedBox(height: 32.h),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: IntlPhoneField(
                                controller: cubit.phoneController,
                                initialCountryCode:
                                    'EG', // كود الدولة الافتراضي (مصر مثلًا)
                                decoration: InputDecoration(
                                  labelText: 'phone_number'.tr(context),
                                  hintText: 'enter_phone'.tr(context),
                                  filled: true,
                                  fillColor: const Color(0xffF0F2F9),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  labelStyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: const BorderSide(
                                        color: Color(0xffF0F2F9)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF1565C0), width: 2),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.r),
                                  ),
                                ),
                                searchText: "search".tr(context),
                                languageCode:
                                    context.read<GlobalCubit>().language,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: const Color(0xFF333333),
                                ),
                                dropdownTextStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF333333),
                                ),
                                onChanged: (phone) {
                                  // cubit.phoneController.text =
                                  //     phone.completeNumber;
                                },
                                invalidNumberMessage: 'invalid_phone'
                                    .tr(context), // لو عندك ترجمة
                              ),
                            ),
                            SizedBox(height: 16.h),
                            AppButton(
                              text: 'next'.tr(context),
                              isLoading: false,
                              onPressed: () {
                                final fullPhone = cubit.phoneController.text;
                                if (fullPhone.isEmpty) {
                                  showToast(context,
                                      message: 'phone_required'.tr(context),
                                      state: ToastStates.error);
                                  return;
                                }
                                cubit.verifyPhoneNumber(context);
                              },
                              height: 50.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 16.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
