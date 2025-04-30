import 'dart:io';
import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/contacts/view/contacts_page.dart';
import 'package:embone/features/client/profile/view/pages/profile_photo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePhotoPage extends StatefulWidget {
  const AddProfilePhotoPage({super.key});

  @override
  State<AddProfilePhotoPage> createState() => _AddProfilePhotoPageState();
}

class _AddProfilePhotoPageState extends State<AddProfilePhotoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        Future<void> pickImage(ImageSource source) async {
          try {
            final ImagePicker picker = ImagePicker();
            final XFile? image = await picker.pickImage(
              source: source,
              imageQuality: 80,
              maxWidth: 800,
              maxHeight: 800,
            );
            if (image != null) {
              final file = XFile(image.path);
              cubit.setProfileImage(file);
              setState(() {});
            }
          } catch (e) {
            if (!context.mounted) return;
            showToast(
              context,
              message: 'error_picking_image'.tr(context),
              state: ToastStates.error,
            );
          }
        }

        void showImageSourceDialog() {
          showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'select_image_source'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  ListTile(
                    leading: const Icon(CupertinoIcons.photo_camera_solid,
                        color: AppColors.primary),
                    title: Text('camera'.tr(context)),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(CupertinoIcons.photo_on_rectangle,
                        color: AppColors.primary),
                    title: Text('gallery'.tr(context)),
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: false,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'register'.tr(context),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: showImageSourceDialog,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    height: 100.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFF5F5F5),
                                    ),
                                    child: cubit.profileImage != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.r),
                                            child: Image.file(
                                              File(cubit.profileImage!.path),
                                              width: 100.w,
                                              height: 100.w,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 40.w,
                                                  height: 40.w,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xFFD9D9D9),
                                                  ),
                                                ),
                                                SizedBox(height: 5.h),
                                                Container(
                                                  width: 50.w,
                                                  height: 20.h,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0xFFD9D9D9),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 24.w,
                                      height: 24.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.grey.shade200,
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        size: 14.w,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                            QuestionWidget(
                              question: 'add_profile_picture'.tr(context),
                              subtitle:
                                  'add_profile_picture_description'.tr(context),
                            ),
                            SizedBox(height: 32.h),
                            AppButton(
                              text: 'upload_photo'.tr(context),
                              isLoading: false,
                              onPressed: cubit.profileImage != null
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                            value: cubit,
                                            child: const ProfilePhotoPage(),
                                          ),
                                        ),
                                      );
                                    }
                                  : showImageSourceDialog,
                              height: 50.h,
                              width: double.infinity,
                            ),
                            SizedBox(height: 16.h),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: cubit,
                                      child: const ContactsPage(),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'skip'.tr(context),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
