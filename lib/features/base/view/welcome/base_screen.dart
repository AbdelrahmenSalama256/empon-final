import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/widgets/nav_bar_item.dart';
import 'package:embone/features/business_account/dashboard/view/dashboard_screen.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/menu/view/menu_screen.dart';
import 'package:embone/features/client/notifications/data/repo/notifications_repo.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_cubit.dart';
import 'package:embone/features/client/shop/data/repo/shop_repo.dart';
import 'package:embone/features/client/shop/view/cubit/shop_cubit.dart';
import 'package:embone/features/client/shop/view/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/client/cart/view/cart_screen.dart';
import 'package:embone/features/client/home/view/home_screen.dart';
import 'package:embone/features/client/notifications/view/notification_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/accounts_bottom_sheet.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  List<Widget> _getScreens(UserType userType) {
    switch (userType) {
      case UserType.client:
        return [
          BlocProvider(
            create: (context) => HomeCubit(sl<HomeRepo>()),
            child: const HomeScreen(),
          ),
          BlocProvider(
            create: (context) => CartCubit(sl<CartRepo>()),
            child: const CartScreen(),
          ),
          BlocProvider(
            create: (context) => ShopCubit(sl<ShopRepo>()),
            child: const ShopScreen(),
          ),
          BlocProvider(
            create: (context) =>
                NotificationsCubit(sl<NotificationsRepo>())..init(),
            child: const NotificationsPage(),
          ),
          const MenuScreen(),
        ];
      case UserType.store:
        return [
          const HomeStoreScreen(),
          const ShopScreen(),
          const SizedBox(),
          const NotificationsPage(),
          const MenuScreen(
            isVendor: true,
          ),
        ];
      case UserType.business:
        return [
          const HomeStoreScreen(),
          const DashboardScreen(),
          const SizedBox(),
          const NotificationsPage(),
          const MenuScreen(
            isVendor: true,
          ),
        ];
    }
  }

  void navigateTo(BuildContext context, Widget screen) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: screen,
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  List<PersistentBottomNavBarItem> _navBarsItems(
      BuildContext context, UserType userType) {
    switch (userType) {
      case UserType.client:
        return [
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/home.svg",
            labelKey: 'nav_home',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/cart.svg",
            labelKey: 'nav_cart',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/shop.svg",
            labelKey: '',
            isCenterItem: true, // Circular shop item
            iconSize: 50.0, // Larger size for shop
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/notification.svg",
            labelKey: 'nav_notification',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/menu.svg",
            labelKey: 'nav_menu',
          ),
        ];
      case UserType.business:
        return [
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/home.svg",
            labelKey: 'nav_home',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/data_info.svg",
            labelKey: 'nav_info',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/shop.svg",
            labelKey: '',
            isCenterItem: true,
            iconSize: 50.0,
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/notification.svg",
            labelKey: 'nav_notification',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/menu.svg",
            labelKey: 'nav_menu',
          ),
        ];
      case UserType.store:
        return [
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/home.svg",
            labelKey: 'nav_home',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/cart.svg",
            labelKey: 'nav_cart',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/shop.svg",
            labelKey: '',
            isCenterItem: true,
            iconSize: 50.0,
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/notification.svg",
            labelKey: 'nav_notification',
          ),
          buildNavBarItem(
            context: context,
            iconPath: "assets/images/svg/nav/menu.svg",
            labelKey: 'nav_menu',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final userType =
            context.read<GlobalCubit>().userType ?? UserType.client;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: PersistentTabView(context,
              controller: context.read<GlobalCubit>().controller,
              screens: _getScreens(userType),
              items: _navBarsItems(context, userType),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              confineToSafeArea: true,
              backgroundColor: Colors.white,
              popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardAppears: true,
              hideOnScrollSettings: const HideOnScrollSettings(
                hideNavBarOnScroll: true,
              ),
              animationSettings: const NavBarAnimationSettings(
                navBarItemAnimation: ItemAnimationSettings(
                  duration: Duration(milliseconds: 200),
                  curve: Curves.ease,
                ),
                screenTransitionAnimation: ScreenTransitionAnimationSettings(
                  animateTabTransition: true,
                  screenTransitionAnimationType:
                      ScreenTransitionAnimationType.fadeIn,
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
                onNavBarHideAnimation: OnHideAnimationSettings(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                ),
              ),
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                ),
                colorBehindNavBar: Colors.white,
              ),
              navBarStyle: NavBarStyle.style15,
              navBarHeight: 80.h, onItemSelected: (index) {
            context.read<GlobalCubit>().changeBottomNavIndex(index);
            if (userType == UserType.store && index == 2) {
              showAccountsBottomSheet(
                  context); // Show bottom sheet instead of navigating
              return; // Return early to prevent navigation
            }
            if (userType == UserType.business && index == 2) {
              showAccountsBottomSheet(
                  context); // Show bottom sheet instead of navigating
              return; // Return early to prevent navigation
            }
          }),
        );
      },
    );
  }
}
