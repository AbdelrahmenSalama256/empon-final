import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/email/another_email_page.dart';
import 'package:embone/features/client/auth/view/pages/email/email_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/add_new_address_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/create_password_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/date_of_birth_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/first_name_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/gender_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/phone_number_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/remember_me_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/terms_conditions_page.dart';
import 'package:embone/features/client/auth/view/pages/verification_screen.dart';
import 'package:embone/features/client/contacts/view/contacts_page.dart';
import 'package:embone/features/client/profile/view/pages/add_profile_photo_page.dart';
import 'package:embone/features/client/profile/view/pages/profile_photo_page.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController();
  late RegisterCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = RegisterCubit(sl<RegisterRepo>());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  void nextStep() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void previousStep() {
    if (_pageController.page?.round() == 0) {
      Navigator.pop(context);
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleRegistrationComplete() {
    nextStep(); // Move to VerificationPage instead of navigating
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                _handleRegistrationComplete();
              }
              if (state is RegisterError) {
                showToast(context,
                    message: state.message, state: ToastStates.error);
              }
              if (state is VerifyOtpSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const BaseScreen()),
                  (route) => false,
                );
              }
              if (state is VerifyOtpError) {
                showToast(context,
                    message: state.message, state: ToastStates.error);
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // CustomHeader(
                    //   showBackButton: true,
                    //   showLogo: true,
                    //   onBackPressed: previousStep,
                    //   title: 'register'.tr(context),
                    // ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          FirstNamePage(
                            onNextStep: nextStep,
                          ),
                          DateOfBirthPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          GenderPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          PhoneNumberPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          CreatePasswordPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          RememberMePage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          TermsConditionsPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          AddNewAddressPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          AddProfilePhotoPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          ProfilePhotoPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          ContactsPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          EmailPage(
                            onNextStep: nextStep,
                            onPreviousStep: previousStep,
                          ),
                          AnotherEmailPage(
                            onPreviousStep: previousStep,
                          ),
                          VerificationPage(
                            onNextStep: () {
                              navigateAndFinish(context, const BaseScreen());
                            },
                            onPreviousStep: previousStep,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
