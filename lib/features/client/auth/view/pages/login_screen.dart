import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/client/auth/data/repo/forget_password_repo.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/forget_password_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/login_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/login_state.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_screen.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/otp_verification_page.dart';
import 'package:embone/features/client/auth/view/pages/searching_account.dart';
import 'package:embone/features/client/auth/view/pages/verification_screen.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<Offset> _logoPositionAnimation;

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _logoPositionAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -0.5),
    ).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _logoAnimationController.forward();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(sl<LoginRepo>()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            showToast(context,
                message: state.message, state: ToastStates.error);
          } else if (state is LoginSuccess) {
            if (state.isVerified) {
              context.read<GlobalCubit>().getUserProfile();

              navigateAndFinish(context, const BaseScreen());
            } else {
              if (state.isEmail != null) {
                showToast(context,
                    message: 'please_verify_your_email'.tr(context),
                    state: ToastStates.error);
                navigateTo(
                  context,
                  BlocProvider(
                    create: (context) => LoginCubit(sl<LoginRepo>()),
                    child: OtpVerificationPage(
                      phoneNumber:
                          context.read<LoginCubit>().valueController.text,
                    ),
                  ),
                );
              } else {
                showToast(context,
                    message: 'please_verify_your_phone'.tr(context),
                    state: ToastStates.error);
                navigateTo(
                  context,
                  BlocProvider(
                    create: (context) => RegisterCubit(sl<RegisterRepo>()),
                    child: VerificationPage(
                      onNextStep: () {
                        navigateAndFinish(context, const BaseScreen());
                      },
                      onPreviousStep: () {
                        Navigator.pop(context);
                      },
                      // phone:
                      // c.valueController.text,
                    ),
                  ),
                );
              }

              // abdo.salamar@psps.com
              // abdo.salamar@osos.com
              // 01156250673
              // 1111
              // 123456789Aa@
              // 01020697423
            }
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SingleChildScrollView(
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 40.h),
                          Center(
                            child: AnimatedBuilder(
                              animation: _logoAnimationController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: _logoPositionAnimation.value,
                                  child: Transform.scale(
                                    scale: _logoScaleAnimation.value,
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      height: 87.h,
                                      width: 57.w,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 40.h),
                          AppTextField(
                            controller: cubit.valueController,
                            labelText: 'phone_or_email'.tr(context),
                            hintText: 'enter_email'.tr(context),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            prefixIcon: Icon(
                              Icons.phone_android,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.sp,
                            ),
                            validator: (value) => Validators.validateRequired(
                                value, 'phone_or_email'.tr(context), context),
                          ),
                          SizedBox(height: 16.h),
                          AppTextField(
                            controller: cubit.passwordController,
                            labelText: 'password'.tr(context),
                            hintText: 'enter_password'.tr(context),
                            obscureText: true,
                            prefixIcon: Icon(
                              Icons.password,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.sp,
                            ),
                            textInputAction: TextInputAction.done,
                            // validator: (value) =>
                            //     Validators.validatePassword(value, context),
                          ),
                          SizedBox(height: 24.h),
                          AppButton(
                            text: 'sign_in'.tr(context),
                            isLoading: state is LoginLoading,
                            onPressed: () {
                              if (cubit.formKey.currentState?.validate() ??
                                  false) {
                                cubit.login();
                              }
                            },
                            // height: 56.h,
                          ),
                          SizedBox(height: 5.h),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (context) => ForgetPasswordCubit(
                                        sl<ForgetPasswordRepo>()),
                                    child: const SearchingAccountPage(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'forgot_password'.tr(context),
                              style: TextStyle(
                                color: const Color(0xff7C7C7C),
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          AppButton(
                            text: 'create_new_account'.tr(context),
                            type: AppButtonType.secondary,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            // height: 48.h,
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
