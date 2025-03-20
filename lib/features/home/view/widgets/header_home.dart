import 'package:embone/core/component/custom-header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/features/notifications/view/notification_screen.dart';
import 'package:embone/features/search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderHome extends StatelessWidget {
  const HeaderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 0.h,
          ),
          Center(
            child: Image.asset(
              'assets/images/logo_text.png',
              height: 32.h,
              // width: 118.w,
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 2,
            child: CustomHeader(
              showBackButton: false,
              showLogo: false,
              height: 35.h,
              title: "",
              trailing: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.chat_bubble_text,
                      size: 28.h,
                      color: const Color(0xff000000),
                    ),
                    onPressed: () {
                      navigateTo(context, const NotificationsPage());
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.search,
                      size: 28.h,
                      color: const Color(0xff000000),
                    ),
                    onPressed: () {
                      navigateTo(context, const SearchPage());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
