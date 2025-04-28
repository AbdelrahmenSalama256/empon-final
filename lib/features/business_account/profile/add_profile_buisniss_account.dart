import 'dart:io';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/contacts/invite_contacts_buisniss.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddProfilePhotoForBuisnissAccountPage extends StatefulWidget {
  const AddProfilePhotoForBuisnissAccountPage({
    super.key,
  });

  @override
  State<AddProfilePhotoForBuisnissAccountPage> createState() =>
      _AddProfilePhotoForBuisnissAccountPageState();
}

class _AddProfilePhotoForBuisnissAccountPageState
    extends State<AddProfilePhotoForBuisnissAccountPage> {
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
            builder: (context) => const InviteContactsInBuisnissAccountPage(),
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
                      question: 'add_business_account_image'.tr(context),
                      subtitle: 'add_logo_for_business_recognition'.tr(context),
                      // padding: EdgeInsets.symmetric(horizontal: 24.w),
                    ),

                    SizedBox(height: 32.h),
                    Column(
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
                                        borderRadius:
                                            BorderRadius.circular(50.r),
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

                        // Buttons
                        AppButton(
                          text: 'next'.tr(context),
                          isLoading: _isLoading,
                          onPressed: _selectedImage != null
                              ? _continueWithPhoto
                              : _showImageSourceDialog,
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
      ),
    );
  }
}
