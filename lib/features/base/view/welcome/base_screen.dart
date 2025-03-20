// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/home/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold(),
  ];

  void _onItemTapped(int index) {
    if (index == 1 || index == 3 || index == 4) {
      // if (sl<CacheHelper>().getDataString(key: ApiKey.token) != null) {
      //   setState(() {
      //     _selectedIndex = index;
      //   });
      //   pageController.jumpToPage(index);
      // } else {
      //   // navigateTo(
      //   //   context,
      //   //   BlocProvider(
      //   //     create: (context) => AuthCubit(),
      //   //     child: Login(),
      //   //   ),
      //   // );
      // }
    } else {
      setState(() {
        _selectedIndex = index;
      });
      pageController.jumpToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex != 0) {
          _onItemTapped(0); // Return to home
          return false;
        }
        return true; // Allow exit from the home screen
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _screens.length,
          controller: pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
        bottomNavigationBar: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/icons/nav/Union.svg",
                height: 107.h,
              ),
            ),
            BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.transparent,
              notchMargin: 8.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildNavBarItem(
                    icon: "assets/icons/nav/home.svg",
                    index: 0,
                    label: 'nav_home'.tr(context),
                  ),
                  _buildNavBarItem(
                    icon: "assets/icons/nav/love.svg",
                    index: 1,
                    label: 'nav_wishlist'.tr(context),
                  ),
                  const SizedBox(width: 50),
                  _buildNavBarItem(
                    icon: "assets/icons/nav/cart.svg",
                    index: 3,
                    label: 'nav_cart'.tr(context),
                  ),
                  _buildNavBarItem(
                    icon: "assets/icons/nav/user.svg",
                    index: 4,
                    label: 'nav_profile'.tr(context),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 43.h,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  _onItemTapped(2);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset("assets/icons/nav/shop.svg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBarItem({
    required String icon,
    required int index,
    required String label,
  }) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            height: 24.h,
            width: 24.w,
          ),
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
