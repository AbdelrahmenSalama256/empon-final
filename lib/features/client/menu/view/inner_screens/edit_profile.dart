import 'dart:io';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/gender_card_selection.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/menu/view/inner_screens/change_password_profile_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageEnState();
}

class _EditProfilePageEnState extends State<EditProfilePage> {
  File? _profileImage;
  Gender _selectedGender = Gender.male; // Non-nullable with default value

  final TextEditingController _phoneController = TextEditingController(
    text: '01221111478',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'sofia@gmail.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '********',
  );
  final String _userName = 'Sofia Amin';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  void _saveChanges() {
    setState(() {
      _isLoading = true;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            AppHeader(
              title: 'edit_profile'.tr(context),
              showBackButton: true,
              centerTitle: true,
              style: HeaderStyle.standard,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile image
                    Center(
                      child: ProfileImagePicker(
                        profileImage: _profileImage,
                        onPickImage: _pickImage,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // User name
                    Center(
                      child: Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Gender selection
                    Text(
                      "edit_gender".tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8F95AB),
                      ),
                      // textAlign: TextAlign.,
                    ),
                    SizedBox(height: 10.h),
                    GenderSelectionCard(
                      selectedGender: _selectedGender,
                      onGenderChanged: (Gender value) {
                        setState(() {
                          _selectedGender = value;
                        });
                      },
                    ),

                    SizedBox(height: 24.h),

                    // Phone number
                    Text(
                      "edit_phone_number".tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8F95AB),
                      ),
                      // textAlign: TextAlign.,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _phoneController,
                            labelText: 'phone_number'.tr(context),
                            hintText: 'enter_phone'.tr(context),
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            suffixIcon: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                size: 20.sp,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                              ),
                              onPressed: () => _showEditDialog(
                                'phone_number'.tr(context),
                                _phoneController,
                                TextInputType.phone,
                                [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),

                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.w,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) =>
                                Validators.validatePhone(value, context),
                            readOnly: true, // Make it read-only by default
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Email
                    Text(
                      "edit_email_address".tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8F95AB),
                      ),
                      // textAlign: TextAlign.,
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _emailController,
                            labelText: 'edit_email_address'.tr(context),
                            hintText: 'enter_email'.tr(context),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.w,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                size: 20.sp,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                              ),
                              onPressed: () => _showEditDialog(
                                'enter_email'.tr(context),
                                _phoneController,
                                TextInputType.phone,
                                [FilteringTextInputFormatter.digitsOnly],
                              ),
                            ),

                            validator: (value) =>
                                Validators.validateEmail(value, context),
                            readOnly: true, // Make it read-only by default
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),

                    // change Password
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
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _passwordController,
                            labelText: 'old_password'.tr(context),
                            hintText: 'old_password'.tr(context),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              // ignore: deprecated_member_use
                              color: const Color(0xff8F95AB).withOpacity(0.7),
                              size: 24.w,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                CupertinoIcons.pencil,
                                size: 20.sp,
                                // ignore: deprecated_member_use
                                color: const Color(0xff8F95AB).withOpacity(0.7),
                              ),
                              onPressed: () {
                                navigateTo(
                                  context,
                                  const ChangePasswordProfileScreen(),
                                );
                              },
                            ),
                            onTap: () {
                              () {
                                navigateTo(
                                  context,
                                  const ChangePasswordProfileScreen(),
                                );
                              };
                            },
                            validator: (value) =>
                                Validators.validateEmail(value, context),
                            readOnly: true, // Make it read-only by default
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32.h),

                    // Save button
                    AppButton(
                      text: 'save_changes'.tr(context),
                      onPressed: _saveChanges,
                      isLoading: _isLoading,
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
  }

  void _showEditDialog(
    String title,
    TextEditingController controller,
    TextInputType keyboardType,
    List<TextInputFormatter> inputFormatters,
  ) {
    final TextEditingController tempController = TextEditingController(
      text: controller.text,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        alignment: Alignment.center,
        title: Text(
          title,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: AppTextField(
          controller: tempController,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'cancel'.tr(context),
              style: TextStyle(color: Colors.grey, fontSize: 16.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                controller.text = tempController.text;
              });
              Navigator.pop(context);
            },
            child: Text(
              'save'.tr(context),
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
