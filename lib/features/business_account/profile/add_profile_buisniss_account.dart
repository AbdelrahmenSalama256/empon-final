import 'dart:io';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/business_account_success_page.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePhotoForBuisnissAccountPage extends StatefulWidget {
  final AccountCubit cubit;
  const AddProfilePhotoForBuisnissAccountPage({
    super.key,
    required this.cubit,
  });

  @override
  State<AddProfilePhotoForBuisnissAccountPage> createState() =>
      _AddProfilePhotoForBuisnissAccountPageState();
}

class _AddProfilePhotoForBuisnissAccountPageState
    extends State<AddProfilePhotoForBuisnissAccountPage> {
  File? _selectedLogo;
  File? _selectedCover;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source, {required bool isLogo}) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image != null) {
        setState(() {
          if (isLogo) {
            _selectedLogo = File(image.path);
            widget.cubit.files.add(image); // Add to cubit for API submission
          } else {
            _selectedCover = File(image.path);
            widget.cubit.files.add(image); // Add to cubit for API submission
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_picking_image'.tr(context))),
      );
    }
  }

  void _showImageSourceDialog({required bool isLogo}) {
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
                _pickImage(ImageSource.camera, isLogo: isLogo);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo_on_rectangle,
                  color: AppColors.primary),
              title: Text('gallery'.tr(context)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isLogo: isLogo);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _continueWithPhotos() {
    if (_selectedLogo != null && _selectedCover != null) {
      setState(() {
        _isLoading = true;
      });

      // Call createAccount
      widget.cubit.createAccount();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please_select_both_images'.tr(context))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.cubit,
      child: BlocConsumer<AccountCubit, AccountState>(
        listener: (context, state) {
          if (state is AccountSuccess) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BusinessAccountSuccessPage(),
              ),
            );
          } else if (state is AccountError) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.massage)),
            );
          }
        },
        builder: (context, state) {
          PrintUtil.debug(widget.cubit.selectedCityId);
          PrintUtil.debug(widget.cubit.nameController.text);
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Header Section
                      AppHeader(
                        title: 'continue_business_account'.tr(context),
                        centerTitle: true,
                        showBackButton: true,
                        onBackPressed: () => Navigator.pop(context),
                        style: HeaderStyle.standard,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Section
                              SizedBox(height: 20.h),
                              QuestionWidget(
                                question:
                                    'add_business_account_image'.tr(context),
                                subtitle: 'add_logo_and_cover_for_business'
                                    .tr(context),
                              ),
                              SizedBox(height: 32.h),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Logo Section
                                  Text(
                                    'business_logo'.tr(context),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: () =>
                                        _showImageSourceDialog(isLogo: true),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 100.w,
                                          height: 100.w,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF5F5F5),
                                          ),
                                          child: _selectedLogo != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.r),
                                                  child: Image.file(
                                                    _selectedLogo!,
                                                    width: 100.w,
                                                    height: 100.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 40.w,
                                                        height: 40.w,
                                                        decoration:
                                                            const BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color:
                                                              Color(0xFFD9D9D9),
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.h),
                                                      Container(
                                                        width: 50.w,
                                                        height: 20.h,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xFFD9D9D9),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                  SizedBox(height: 32.h),
                                  // Cover Image Section
                                  Text(
                                    'cover_image'.tr(context),
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.black,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  GestureDetector(
                                    onTap: () =>
                                        _showImageSourceDialog(isLogo: false),
                                    child: Container(
                                      width: double.infinity,
                                      height: 150.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F5F5),
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                      ),
                                      child: _selectedCover != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                              child: Image.file(
                                                _selectedCover!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image,
                                                    size: 40.sp,
                                                    color:
                                                        const Color(0xFFD9D9D9),
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    'upload_cover_image'
                                                        .tr(context),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: const Color(
                                                          0xFFD9D9D9),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 24.h),
                                  // Buttons
                                  AppButton(
                                    text: 'confirm_and_create'.tr(context),
                                    isLoading: _isLoading,
                                    onPressed: _continueWithPhotos,
                                    height: 50.h,
                                    width: double.infinity,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (state is AccountLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
