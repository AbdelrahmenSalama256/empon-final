import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/friend_reqeests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: "settings".tr(context),
      showBackButton: true,
      centerTitle: true,
      alignment: HeaderAlignment.spaceBetween,
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          tooltip: "friend_requests".tr(context),
          icon: Icon(
            CupertinoIcons.person_3_fill,
            color: AppColors.primary,
            size: 25.sp,
          ),
          onPressed: () {
            // Navigate to settings page or perform any action
            navigateTo(context, const FriendRequestsPage());
          },
        ),
      ],
    );
  }
}
