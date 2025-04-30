import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileSetupPage extends StatefulWidget {
  final String email;
  final String password;
  final String firstName;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final bool rememberMe;

  const ProfileSetupPage({
    super.key,
    required this.email,
    required this.password,
    required this.firstName,
    required this.dateOfBirth,
    required this.gender,
    required this.phoneNumber,
    required this.rememberMe,
  });

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _completeSetup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        // Navigate to home page or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('profile_setup_complete'.tr(context))),
        );

        // In a real app, you would navigate to the home screen
        // Navigator.pushAndRemoveUntil(...)
      });
    }
  }

  void _skipSetup() {
    // Navigate to home page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('profile_setup_skipped'.tr(context))),
    );

    // In a real app, you would navigate to the home screen
    // Navigator.pushAndRemoveUntil(...)
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'profile_setup'.tr(context),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            isRTL ? Icons.arrow_forward : Icons.arrow_back,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // EMPON logo at the top
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/empon_logo.png',
                        height: 24,
                      ),
                      const Icon(
                        Icons.language,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                // Profile photo
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.background,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'add_profile_photo'.tr(context),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
                // Title and subtitle
                Text(
                  'profile_photo_title'.tr(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'profile_photo_subtitle'.tr(context),
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.h),
                // Username field
                AppTextField(
                  controller: _usernameController,
                  labelText: 'username'.tr(context),
                  hintText: 'enter_username'.tr(context),
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.alternate_email),
                  validator: (value) => Validators.validateRequired(
                    value,
                    'username'.tr(context),
                    context,
                  ),
                ),
                const SizedBox(height: 16),
                // Bio field
                AppTextField(
                  controller: _bioController,
                  labelText: 'bio'.tr(context),
                  hintText: 'enter_bio'.tr(context),
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.info_outline),
                  maxLines: 3,
                ),
                SizedBox(height: 32.h),
                // Complete setup button
                AppButton(
                  text: 'complete_setup'.tr(context),
                  isLoading: _isLoading,
                  onPressed: _completeSetup,
                ),
                const SizedBox(height: 16),
                // Skip for now
                TextButton(
                  onPressed: _skipSetup,
                  child: Text(
                    'skip_for_now'.tr(context),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Progress indicator
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '7/7',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
