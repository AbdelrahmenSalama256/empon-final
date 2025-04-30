import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_step_indicator.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/add_new_address_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

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
                  showBackButton: false,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'register'.tr(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppStepIndicator(currentStep: 7, totalSteps: 8),
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
                          question: 'terms_and_conditions'.tr(context),
                          subtitle:
                              'terms_and_conditions_description'.tr(context),
                        ),
                        SizedBox(height: 16.h),
                        AppButton(
                          text: 'agree'.tr(context),
                          isLoading: false,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider.value(
                                  value: cubit,
                                  child: const AddNewAddressPage(),
                                ),
                              ),
                            );
                          },
                          height: 50.h,
                          width: double.infinity,
                        ),
                        SizedBox(height: 30.h),
                      ],
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
