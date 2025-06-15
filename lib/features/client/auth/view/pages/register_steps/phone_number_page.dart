import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

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
          showToast(context, message: state.error, state: ToastStates.error);
        }
        if (state is VerifyPhoneNumberSuccess) {
          PrintUtil.success('Phone number verified successfully');
          showToast(context, message: state.message, state: ToastStates.success);
          widget.onNextStep();
        }},
      child:SafeArea(
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
                      const AppStepIndicator(currentStep: 4, totalSteps: 8),
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
                      AppTextField(
                        controller: cubit.phoneController,
                        labelText: 'phone_number'.tr(context),
                        hintText: 'enter_phone'.tr(context),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: const Color(0xff8F95AB)
                              .withAlpha((0.7 * 255).toInt()),
                          size: 24.w,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      SizedBox(height: 16.h),
                      AppButton(
                        text: 'next'.tr(context),
                        isLoading: false,
                        onPressed: () {
                          if (cubit.phoneController.text.isEmpty) {
                            showToast(context,
                                message: 'phone_required'.tr(context),
                                state: ToastStates.error);
                            return;
                          }else{
                            cubit.verifyPhoneNumber(cubit.phoneController.text);
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