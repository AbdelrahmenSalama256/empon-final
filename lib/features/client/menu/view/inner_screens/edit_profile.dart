import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/gender_card_selection.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/menu/view/inner_screens/change_password_profile_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageEnState();
}

class _EditProfilePageEnState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late Gender _selectedGender;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GlobalCubit>();
    _firstNameController = TextEditingController(text: cubit.userName ?? '');
    _lastNameController = TextEditingController(text: cubit.userLastName ?? '');
    _phoneController = TextEditingController(text: cubit.userPhone ?? '');
    _emailController = TextEditingController(text: cubit.userEmail ?? '');
    _selectedGender = cubit.userGender == 'male'
        ? Gender.male
        : cubit.userGender == 'female'
            ? Gender.female
            : Gender.other;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
      setState(() {});
    }
  }

  Future<void> _saveChanges() async {
    setState(() {
      _isLoading = true;
    });

    // Validate inputs
    final phoneValidation =
        Validators.validatePhone(_phoneController.text, context);
    final emailValidation =
        Validators.validateEmail(_emailController.text, context);
    final firstNameValidation =
        Validators.validateName(_firstNameController.text, context);
    final lastNameValidation =
        Validators.validateName(_lastNameController.text, context);

    if (firstNameValidation != null) {
      showToast(context,
          message: firstNameValidation, state: ToastStates.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (lastNameValidation != null) {
      showToast(context, message: lastNameValidation, state: ToastStates.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (phoneValidation != null) {
      showToast(context, message: phoneValidation, state: ToastStates.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (emailValidation != null) {
      showToast(context, message: emailValidation, state: ToastStates.error);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Update profile via cubit
    // await context.read<GlobalCubit>().updateUserProfile(
    //       firstName: _firstNameController.text,
    //       lastName: _lastNameController.text,
    //       phone: _phoneController.text,
    //       email: _emailController.text,
    //       gender: _selectedGender.name,
    //       image: _profileImage,
    //     );

    setState(() {
      _isLoading = false;
    });
  }

  void _showEditBottomSheet({
    required String title,
    required TextEditingController controller,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final TextEditingController tempController = TextEditingController(
      text: controller.text,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16.w,
          right: 16.w,
          top: 16.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: tempController,
                keyboardType: keyboardType,
                inputFormatters: inputFormatters,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
                autofocus: true,
                validator: validator,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'cancel'.tr(context),
                      style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final validationError =
                          validator?.call(tempController.text);
                      if (validationError != null) {
                        showToast(context,
                            message: validationError, state: ToastStates.error);
                        return;
                      }
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
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer({
    required String label,
    required String data,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: const Color(0xff8F95AB),
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xffF0F2F9)),
              color: const Color(0xffF0F2F9),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  // ignore: deprecated_member_use
                  color: const Color(0xff8F95AB).withOpacity(0.7),
                  size: 24.w,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    data.isEmpty ? 'Not set' : data,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8F95AB).withOpacity(0.7),
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.pencil,
                  size: 20.sp,
                  color: const Color(0xff8F95AB).withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<GlobalCubit, GlobalState>(
        listener: (context, state) {
          if (state is ProfileError) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
            setState(() {
              _isLoading = false;
            });
          } else if (state is ProfileLoaded) {
            showToast(
              context,
              message: 'profile_updated_successfully'.tr(context),
              state: ToastStates.success,
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          final cubit = context.read<GlobalCubit>();
          return SafeArea(
            child: Column(
              children: [
                AppHeader(
                  title: 'edit_profile'.tr(context),
                  showBackButton: true,
                  centerTitle: true,
                  style: HeaderStyle.standard,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),
                        if (state is ProfileLoading)
                          const Center(child: CircularProgressIndicator())
                        else
                          Center(
                            child: ProfileSection(
                              userName:
                                  "${cubit.userName ?? ''} ${cubit.userLastName ?? ''}"
                                      .trim(),
                              userImageUrl: cubit.userAvatar ??
                                  'assets/images/profile.png',
                              subtitle: '',
                              isVendor: false,
                              onTap: () {},
                            ),
                          ),
                        SizedBox(height: 16.h),
                        _buildFieldContainer(
                          label: "edit_first_name".tr(context),
                          data: _firstNameController.text,
                          icon: Icons.person_outline,
                          onTap: () => _showEditBottomSheet(
                            title: 'edit_first_name'.tr(context),
                            controller: _firstNameController,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                Validators.validateName(value, context),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildFieldContainer(
                          label: "edit_last_name".tr(context),
                          data: _lastNameController.text,
                          icon: Icons.person_outline,
                          onTap: () => _showEditBottomSheet(
                            title: 'edit_last_name'.tr(context),
                            controller: _lastNameController,
                            keyboardType: TextInputType.name,
                            validator: (value) =>
                                Validators.validateName(value, context),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "edit_gender".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff8F95AB),
                          ),
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
                        _buildFieldContainer(
                          label: "edit_phone_number".tr(context),
                          data: _phoneController.text,
                          icon: Icons.phone_outlined,
                          onTap: () => _showEditBottomSheet(
                            title: 'edit_phone_number'.tr(context),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) =>
                                Validators.validatePhone(value, context),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _buildFieldContainer(
                          label: "edit_email_address".tr(context),
                          data: _emailController.text,
                          icon: Icons.email_outlined,
                          onTap: () => _showEditBottomSheet(
                            title: 'edit_email_address'.tr(context),
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                Validators.validateEmail(value, context),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          "edit_password".tr(context),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff8F95AB),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            navigateTo(
                                context, const ChangePasswordProfileScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              border:
                                  Border.all(color: const Color(0xffF0F2F9)),
                              color: const Color(0xffF0F2F9),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color:
                                      const Color(0xff8F95AB).withOpacity(0.7),
                                  size: 24.w,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    'change_password'.tr(context),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff8F95AB)
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                Icon(
                                  CupertinoIcons.pencil,
                                  size: 20.sp,
                                  color:
                                      const Color(0xff8F95AB).withOpacity(0.7),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
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
          );
        },
      ),
    );
  }
}
