import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/searching_account.dart';
import 'package:embone/features/client/auth/view/pages/welcom_screen.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

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
      begin: const Offset(0, 0), // Start from the current position
      end: const Offset(0, -0.5), // Move upward
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
    _emailController.dispose();
    _passwordController.dispose();
    _logoAnimationController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        showToast(context,
            message: 'login_success'.tr(context), state: ToastStates.success);
      });
      navigateAndFinish(context, const BaseScreen());
      // Navigate to home screen or any other page after successful login
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
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
                      controller: _emailController,
                      labelText: 'phone_or_email'.tr(context),
                      hintText: 'enter_email'.tr(context),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icon(Icons.phone_android,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.sp),
                      validator: (value) =>
                          Validators.validateEmail(value, context),
                    ),
                    SizedBox(height: 16.h),
                    AppTextField(
                      controller: _passwordController,
                      labelText: 'password'.tr(context),
                      hintText: 'enter_password'.tr(context),
                      obscureText: true,
                      prefixIcon: Icon(Icons.password,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.sp),
                      textInputAction: TextInputAction.done,
                      validator: (value) =>
                          Validators.validatePassword(value, context),
                    ),
                    SizedBox(height: 24.h),
                    AppButton(
                      text: 'sign_in'.tr(context),
                      isLoading: _isLoading,
                      onPressed: _login,
                      height: 56.h,
                    ),
                    SizedBox(height: 5.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SearchingAccountPage(),
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
                                builder: (context) => const WelcomePage()));
                      },
                      height: 48.h,
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
  }
}
