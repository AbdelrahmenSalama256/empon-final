import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/login_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/login_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/otp_verification_page.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/gender_card_selection.dart';
import 'package:embone/features/client/menu/view/inner_screens/change_password_profile_screen.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageEnState();
}

class _EditProfilePageEnState extends State<EditProfilePage> {
  late String originalFirstName;
  late String originalLastName;
  late String originalPhone;
  late String originalEmail;
  late String originalAnotherEmail;
  late String originalBirthDate;
  late Gender originalGender;
  late XFile? originalProfileImage;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<GlobalCubit>();
    cubit.initProfileData();
    originalFirstName = cubit.firstNameController.text;
    originalLastName = cubit.lastNameController.text;
    originalPhone = cubit.phoneController.text;
    originalEmail = cubit.emailController.text;
    originalAnotherEmail = cubit.anotherEmailController.text;
    originalBirthDate = cubit.birthDateController.text;
    originalGender = cubit.selectedGender;
    originalProfileImage = cubit.profileImage;
  }

  bool _hasChanges(GlobalCubit cubit) {
    return cubit.firstNameController.text != originalFirstName ||
        cubit.lastNameController.text != originalLastName ||
        cubit.phoneController.text != originalPhone ||
        cubit.emailController.text != originalEmail ||
        cubit.anotherEmailController.text != originalAnotherEmail ||
        cubit.birthDateController.text != originalBirthDate ||
        cubit.selectedGender != originalGender ||
        cubit.profileImage != originalProfileImage;
  }

  Future<void> _selectDate(BuildContext context, GlobalCubit cubit) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        cubit.birthDateController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();

        return BlocListener<GlobalCubit, GlobalState>(
          listener: (context, state) {
            if (state is ProfileError) {
              showToast(context,
                  message: state.message, state: ToastStates.error);
            } else if (state is ProfileUpdated) {
              showToast(context,
                  message: 'profile_updated_successfully'.tr(context),
                  state: ToastStates.success);
              setState(() {
                originalFirstName = cubit.firstNameController.text;
                originalLastName = cubit.lastNameController.text;
                originalPhone = cubit.phoneController.text;
                originalEmail = cubit.emailController.text;
                originalAnotherEmail = cubit.anotherEmailController.text;
                originalBirthDate = cubit.birthDateController.text;
                originalGender = cubit.selectedGender;
                originalProfileImage = cubit.profileImage;
              });

              // cubit.getUserProfile();
            }
            if (cubit.userPhoneVerified == false) {
              showToast(context,
                  message: 'please_verify_your_phone'.tr(context),
                  state: ToastStates.error);
              navigateTo(
                context,
                BlocProvider(
                  create: (context) => LoginCubit(sl<LoginRepo>()),
                  child: OtpVerificationPage(
                    phoneNumber: cubit.phoneController.text,
                  ),
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          state is ProfileLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: ProfileSection(
                                    userName:
                                        "${cubit.firstNameController.text} ${cubit.lastNameController.text}"
                                            .trim(),
                                    userImageUrl: cubit.userAvatar ??
                                        'assets/images/logo.png',
                                    subtitle: '',
                                    isVendor: false,
                                    onTap: () {},
                                  ),
                                ),
                          SizedBox(height: 16.h),
                          _buildFieldContainer(
                            label: "first_name".tr(context),
                            data: cubit.firstNameController.text,
                            icon: Icons.person_outline,
                            onTap: () => _showEditBottomSheet(
                              title: 'edit_first_name'.tr(context),
                              controller: cubit.firstNameController,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _buildFieldContainer(
                            label: "last_name".tr(context),
                            data: cubit.lastNameController.text,
                            icon: Icons.person_outline,
                            onTap: () => _showEditBottomSheet(
                              title: 'edit_last_name'.tr(context),
                              controller: cubit.lastNameController,
                              keyboardType: TextInputType.name,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          _buildFieldContainer(
                            label: "phone_number".tr(context),
                            data: cubit.phoneController.text,
                            icon: Icons.phone_outlined,
                            onTap: cubit.userPhoneVerified == false
                                ? () {
                                    showToast(context,
                                        message: 'please_verify_your_phone'
                                            .tr(context),
                                        state: ToastStates.error);
                                    navigateWithoutNav(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            LoginCubit(sl<LoginRepo>()),
                                        child: OtpVerificationPage(
                                          phoneNumber:
                                              cubit.phoneController.text,
                                          type: "verify-phone",
                                        ),
                                      ),
                                    );
                                  }
                                : () => _showEditBottomSheet(
                                      title: 'edit_phone_number'.tr(context),
                                      controller: cubit.phoneController,
                                      keyboardType: TextInputType.phone,
                                    ),
                            trailing: cubit.userPhoneVerified == false
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'not_verified'.tr(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 24.h),
                          _buildFieldContainer(
                            label: "email_address".tr(context),
                            data: cubit.emailController.text,
                            icon: Icons.email_outlined,
                            onTap: cubit.userEmailVerified == false
                                ? () {
                                    showToast(context,
                                        message: 'please_verify_your_email'
                                            .tr(context),
                                        state: ToastStates.error);
                                    navigateWithoutNav(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            LoginCubit(sl<LoginRepo>()),
                                        child: OtpVerificationPage(
                                          phoneNumber:
                                              cubit.emailController.text,
                                        ),
                                      ),
                                    );
                                  }
                                : () => _showEditBottomSheet(
                                      title: 'edit_email_address'.tr(context),
                                      controller: cubit.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                            trailing: cubit.userEmailVerified == false
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'not_verified'.tr(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 24.h),
                          _buildFieldContainer(
                            label: "another_email".tr(context),
                            data: cubit.anotherEmailController.text,
                            icon: Icons.email_outlined,
                            onTap: () => _showEditBottomSheet(
                              title: 'edit_another_email'.tr(context),
                              controller: cubit.anotherEmailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            trailing: cubit.anotherEmailController.text
                                        .isNotEmpty &&
                                    cubit.userAnotherEmailVerified == false
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 4.h),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Text(
                                      'not_verified'.tr(context),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 24.h),
                          _buildFieldContainer(
                            label: "birth_date".tr(context),
                            data: cubit.birthDateController.text,
                            icon: Icons.calendar_today,
                            onTap: () => _selectDate(context, cubit),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "gender".tr(context),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff8F95AB),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          GenderSelectionCard(
                            selectedGender: cubit.selectedGender,
                            onGenderChanged: (Gender value) {
                              cubit.setGender(value);
                            },
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            "change_password".tr(context),
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
                                  horizontal: 16.w, vertical: 16.h),
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
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
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
                                    color: const Color(0xff8F95AB)
                                        .withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 32.h),
                          if (_hasChanges(cubit))
                            AppButton(
                              text: 'save_changes'.tr(context),
                              onPressed: cubit.updateUserProfile,
                              isLoading: cubit.isLoading,
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
          ),
        );
      },
    );
  }

  void _showEditBottomSheet({
    required String title,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    final TextEditingController tempController =
        TextEditingController(text: controller.text);

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
              TextField(
                controller: tempController,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                autofocus: true,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'cancel'.tr(context),
                        style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      onPressed: () {
                        setState(() {
                          controller.text = tempController.text;
                        });
                        Navigator.pop(context);
                      },
                      text: 'save'.tr(context),
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
    Widget? trailing,
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: const Color(0xffF0F2F9)),
              color: const Color(0xffF0F2F9),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
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
                if (trailing != null) ...[
                  trailing,
                  SizedBox(width: 8.w),
                ],
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
}
