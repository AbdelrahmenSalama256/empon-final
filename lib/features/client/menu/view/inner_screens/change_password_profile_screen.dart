import 'dart:io';

import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ChangePasswordProfileScreen extends StatefulWidget {
  const ChangePasswordProfileScreen({super.key});

  @override
  State<ChangePasswordProfileScreen> createState() =>
      _ChangePasswordProfileScreenState();
}

class _ChangePasswordProfileScreenState
    extends State<ChangePasswordProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  File? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _passwordController.text = widget.password;
  // }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            //! Header Section
            AppHeader(
              title: 'edit_password'.tr(context),
              showBackButton: true,
              centerTitle: true,
              style: HeaderStyle.standard,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //! Step Indicator Section
                      // const AppStepIndicator(
                      //   currentStep: 6,
                      //   totalSteps: 8,
                      // ),
                      SizedBox(height: 16.h),

                      //! Profile Image
                      Center(
                        child: ProfileImagePicker(
                          profileImage: _profileImage,
                          onPickImage: _pickImage,
                        ),
                      ),

                      SizedBox(height: 16.h),
                      Text(
                        "edit_password".tr(context),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff8F95AB),
                        ),
                        // textAlign: TextAlign.,
                      ),
                      SizedBox(height: 10.h),

                      //! Old Password Section
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'old_password'.tr(context),
                        hintText: 'enter_old_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, context),
                      ),
                      SizedBox(height: 16.h),

                      //! Password Input Section
                      AppTextField(
                        controller: _passwordController,
                        labelText: 'password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validatePassword(value, context),
                      ),
                      SizedBox(height: 16.h),

                      //! Confirm Password Input Section
                      AppTextField(
                        controller: _confirmPasswordController,
                        labelText: 'confirm_password'.tr(context),
                        hintText: 'enter_password'.tr(context),
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        prefixIcon: Icon(
                          Icons.password_outlined,
                          // ignore: deprecated_member_use
                          color: const Color(0xff8F95AB).withOpacity(0.7),
                          size: 24.w,
                        ),
                        validator: (value) =>
                            Validators.validateConfirmPassword(
                          value,
                          _passwordController.text,
                          context,
                        ),
                      ),
                      SizedBox(height: 32.h.h),

                      //! Button Section
                      AppButton(
                        text: 'next'.tr(context),
                        isLoading: _isLoading,
                        onPressed: _continue,
                        height: 50.h,
                        width: double.infinity,
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
