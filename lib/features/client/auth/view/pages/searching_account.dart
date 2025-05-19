import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_state.dart';
import 'package:embone/features/client/auth/view/pages/finding_accounts.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingAccountPage extends StatelessWidget {
  const SearchingAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          final user = state.data;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    ForgetPasswordCubit(sl<ForgetPasswordRepo>()),
                child: FindingAccountsPage(
                  email: user!.email,
                  phoneNumber: user.phone,
                  firstName: user.firstName,
                  imageUrl: user.image,
                ),
              ),
            ),
          );
        }
        if (state is ForgotPasswordFailure) {
          showToast(
            context,
            message: state.message,
            state: ToastStates.error,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ForgetPasswordCubit>();
        final isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          backgroundColor: AppColors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: true,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'search_account'.tr(context),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Form(
                          key: cubit.formKey,
                          child: Column(
                            crossAxisAlignment: isRTL
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
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
                                question: 'search_for_accounts'.tr(context),
                                subtitle:
                                    'search_account_description'.tr(context),
                              ),
                              SizedBox(height: 10.h),
                              AppTextField(
                                controller: cubit.valueController,
                                labelText: 'phone_or_email'.tr(context),
                                hintText: 'enter_phone_or_email'.tr(context),
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color:
                                      // ignore: deprecated_member_use
                                      const Color(0xff8F95AB).withOpacity(0.7),
                                  size: 24.w,
                                ),
                                validator: (value) =>
                                    Validators.validateRequired(
                                        value,
                                        'enter_phone_or_email'.tr(context),
                                        context),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                'search_account_hint'.tr(context),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff7C7C7C),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32.h),
                              AppButton(
                                text: 'search_do'.tr(context),
                                isLoading: isLoading,
                                onPressed: () => cubit.forgotPassword(),
                                height: 50.h,
                                width: double.infinity,
                              ),
                              SizedBox(height: 16.h),
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
      },
    );
  }
}
