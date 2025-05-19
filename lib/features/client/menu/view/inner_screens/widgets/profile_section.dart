import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/profile_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSection extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      buildWhen: (previous, current) =>
          current is ProfileDataUpdated || current is ProfileLoaded,
      builder: (context, state) {
        final cubit = context.read<GlobalCubit>();
        return Column(
          children: [
            // Profile Image Container
            if (isAddNew)
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: borderColor ?? Colors.grey,
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
                profileImage: cubit.profileImage,
                networkImageUrl: userImageUrl,
                onImagePicked: (XFile? image) {
                  if (image != null) {
                    cubit.setProfileImage(image);
                  }
                },
              ),

            SizedBox(height: 12.h),
            Text(
              userName,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
