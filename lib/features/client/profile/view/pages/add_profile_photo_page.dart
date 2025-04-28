import 'dart:io';
import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/enums/gender_enum.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/contacts/view/contacts_page.dart';
import 'package:embone/features/client/profile/view/pages/profile_photo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePhotoPage extends StatefulWidget {
  final String firstName;
  final String selectedLocation;
  final DateTime dateOfBirth;
  final Gender gender;
  final String phoneNumber;
  final String password;
  const AddProfilePhotoPage(
      {super.key,
      required this.firstName,
      required this.dateOfBirth,
      required this.selectedLocation,
      required this.gender,
      required this.password,
      required this.phoneNumber});

  @override
  State<AddProfilePhotoPage> createState() => _AddProfilePhotoPageState();
}

class _AddProfilePhotoPageState extends State<AddProfilePhotoPage> {
  File? _selectedImage;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    // final status = source == ImageSource.gallery
    //     ? await Permission.photos.request()
    //     : await Permission.photos.request();

    // if (status.isGranted) {
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
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('error_picking_image'.tr(context))),
      );
    }
  }

  void _showImageSourceDialog() {
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(CupertinoIcons.photo_on_rectangle,
                  color: AppColors.primary),
              title: Text('gallery'.tr(context)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _continueWithPhoto() {
    if (_selectedImage != null) {
      setState(() {
        _isLoading = true;
      });

      // Simulate upload process
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePhotoPage(
              profileImage: _selectedImage!,
              firstName: widget.firstName,
              dateOfBirth: widget.dateOfBirth,
              gender: widget.gender,
              phoneNumber: widget.phoneNumber,
              password: widget.password,
              selectedLocation: widget.selectedLocation,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            CustomHeader(
              showBackButton: false,
              showLogo: true,
              onBackPressed: () => Navigator.pop(context),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image Container
                    GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF5F5F5),
                            ),
                            child: _selectedImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50.r),
                                    child: Image.file(
                                      _selectedImage!,
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
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFD9D9D9),
                                          ),
                                        ),
                                        SizedBox(height: 5.h),
                                        Container(
                                          width: 50.w,
                                          height: 20.h,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFD9D9D9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
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

                    // Question Section
                    QuestionWidget(
                      question: 'add_profile_picture'.tr(context),
                      subtitle: 'add_profile_picture_description'.tr(context),
                    ),
                    SizedBox(height: 32.h),

                    // Buttons
                    AppButton(
                      text: 'upload_photo'.tr(context),
                      isLoading: _isLoading,
                      onPressed: _selectedImage != null
                          ? _continueWithPhoto
                          : _showImageSourceDialog,
                      height: 50.h,
                      width: double.infinity,
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPage(
                              profileImage: _selectedImage!,
                              firstName: widget.firstName,
                              dateOfBirth: widget.dateOfBirth,
                              gender: widget.gender,
                              phoneNumber: widget.phoneNumber,
                              password: widget.password,
                              selectedLocation: widget.selectedLocation,
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
            ),
          ],
        ),
      ),
    );
  }
}
