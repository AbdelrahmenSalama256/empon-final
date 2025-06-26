import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/base_screen.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlowStep {
  final Widget Function(VoidCallback goNext, VoidCallback goBack) builder;

  FlowStep({required this.builder});
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late RegisterCubit _cubit;
  late final List<FlowStep> _steps;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _cubit = RegisterCubit(sl<RegisterRepo>());

    _steps = [
      FlowStep(builder: (next, back) => FirstNamePage(onNextStep: next)),
      FlowStep(
          builder: (next, back) =>
              DateOfBirthPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              GenderPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              PhoneNumberPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              CreatePasswordPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              RememberMePage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              TermsConditionsPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              AddNewAddressPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              AddProfilePhotoPage(onNextStep: next, onPreviousStep: back)),
      _cubit.profileImage != null
          ? FlowStep(
              builder: (next, back) =>
                  ProfilePhotoPage(onNextStep: next, onPreviousStep: back))
          : FlowStep(
              builder: (next, back) =>
                  EmailPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              AnotherEmailPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) =>
              VerificationPage(onNextStep: next, onPreviousStep: back)),
      FlowStep(
          builder: (next, back) => ContactsPage(
                onNextStep: () =>
                    navigateAndFinish(context, const BaseScreen()),
                onPreviousStep: back,
              )),
    ];
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void goToNextStep() {
    if (_currentIndex < _steps.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  void goToPreviousStep() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    } else {
      _showCancelConfirmationDialog();
    }
  }

  Future<void> _showCancelConfirmationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'cancel_registration_question'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'cancel_data_loss_warning'.tr(context),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    type: AppButtonType.secondary,
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    text: 'cancel'.tr(context),
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: AppButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    text: 'continue'.tr(context),
                    textStyle: TextStyle(
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _handleRegistrationComplete() {
    goToNextStep();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _cubit,
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            _handleRegistrationComplete();
          }
          if (state is RegisterError) {
            showToast(context,
                message: state.message, state: ToastStates.error);
          }
          if (state is VerifyOtpSuccess) {
            navigateAndFinish(context, const BaseScreen());
          }
          if (state is VerifyOtpError) {
            showToast(context,
                message: state.message, state: ToastStates.error);
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (_currentIndex > 0) {
                goToPreviousStep();
                return false; // Prevent default pop
              } else {
                _showCancelConfirmationDialog();
                return false; // Prevent default pop until dialog decision
              }
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: _steps[_currentIndex]
                    .builder(goToNextStep, goToPreviousStep),
              ),
            ),
          );
        },
      ),
    );
  }
}
