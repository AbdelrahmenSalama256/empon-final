import 'dart:io';

import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSection extends StatefulWidget {
  final String userName;
  final String userImageUrl;
  final String subtitle;
  final bool isVendor;
  final VoidCallback onTap;
  final Color? borderColor;
  final bool isAddNew;

  const ProfileSection({
    super.key,
    required this.userName,
    required this.userImageUrl,
    required this.subtitle,
    this.isVendor = false,
    required this.onTap,
    this.borderColor,
    this.isAddNew = false,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image Container
        if (widget.isAddNew)
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.borderColor ?? Colors.grey,
                  width: 1.w,
                ),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.grey,
                size: 30,
              ),
            ),
          )
        else
          ProfileImagePicker(
            profileImage: _profileImage,
            onPickImage: _pickImage,
            networkImageUrl: widget.userImageUrl,
          ),

        SizedBox(height: 12.h),
        Text(
          widget.userName,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        if (widget.subtitle.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Text(
            widget.subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ],
    );
  }
}
