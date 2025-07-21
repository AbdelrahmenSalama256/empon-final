import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/base/view/welcome/guest_registerd.dart';
import 'package:embone/features/base/view/welcome/intro_screen.dart';
import 'package:embone/features/base/view/widgets/nav_bar_item.dart';
import 'package:embone/features/business_account/dashboard/data/repo/statistics_repo.dart';
import 'package:embone/features/business_account/dashboard/view/cubit/statistics_cubit.dart';
import 'package:embone/features/business_account/dashboard/view/dashboard_screen.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/auth/view/pages/login_screen.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cart_screen.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/home/view/home_screen.dart';
import 'package:embone/features/client/menu/view/menu_screen.dart';
import 'package:embone/features/client/notifications/data/repo/notifications_repo.dart';
import 'package:embone/features/client/notifications/view/cubit/notifications_cubit.dart';
import 'package:embone/features/client/notifications/view/notification_screen.dart';
import 'package:embone/features/client/shop/data/repo/shop_repo.dart';
import 'package:embone/features/client/shop/view/cubit/shop_cubit.dart';
import 'package:embone/features/client/shop/view/shop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cubit/global_state.dart';

class BaseScreen extends StatefulWidget {
  final bool? isGuest;
  const BaseScreen({super.key, this.isGuest});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GlobalCubit>().init(); // Initialize GlobalCubit
  }

  Widget _buildScreen(int index, UserType userType) {
    if (widget.isGuest == true) {
      switch (index) {
        case 0:
          return BlocProvider(
            create: (context) => HomeCubit(sl<HomeRepo>())..init(),
            child: const HomeScreen(),
          );
        case 1:
          return GuestRestrictedScreen(
            isGuest: widget.isGuest ?? false,
            message: "please_login_to_access_your_cart",
            child: BlocProvider(
              create: (context) => CartCubit(sl<CartRepo>()),
              child: const CartScreen(),
            ),
          );
        case 2:
          return BlocProvider(
            create: (context) => ShopCubit(sl<ShopRepo>()),
            child: const ShopScreen(),
          );
        case 3:
          return GuestRestrictedScreen(
            isGuest: widget.isGuest ?? false,
            message: "please_login_to_view_notifications",
            child: BlocProvider(
              create: (context) =>
                  NotificationsCubit(sl<NotificationsRepo>())..init(),
              child: const NotificationsPage(),
            ),
          );
        case 4:
          return GuestRestrictedScreen(
            isGuest: widget.isGuest ?? false,
            message: "please_login_to_access_menu",
            child: const IntroPage(),
          );
        default:
          return const SizedBox.shrink();
      }
    }
    switch (userType) {
      case UserType.client:
        switch (index) {
          case 0:
            return BlocProvider(
              create: (context) => HomeCubit(sl<HomeRepo>())..init(),
              child: const HomeScreen(),
            );
          case 1:
            return BlocProvider(
              create: (context) => CartCubit(sl<CartRepo>()),
              child: const CartScreen(),
            );
          case 2:
            return BlocProvider(
              create: (context) => ShopCubit(sl<ShopRepo>()),
              child: const ShopScreen(),
            );
          case 3:
            return BlocProvider(
              create: (context) =>
                  NotificationsCubit(sl<NotificationsRepo>())..init(),
              child: const NotificationsPage(),
            );
          case 4:
            return const MenuScreen();
          default:
            return const SizedBox.shrink();
        }
      case UserType.store:
        switch (index) {
          case 0:
            return HomeStoreScreen(
              businessAccountId: context.read<GlobalCubit>().businessId,
              isVendor: true,
            );
          case 1:
            return BlocProvider(
              create: (context) => StatisticsCubit(sl<StatisticsRepo>())
                ..fetchStatistics(context.read<GlobalCubit>().businessId),
              child: const DashboardScreen(),
            );
          case 2:
            return BlocProvider(
              create: (context) => NotificationsCubit(sl<NotificationsRepo>()),
              child: const NotificationsPage(),
            );
          case 3:
            return const MenuScreen(isVendor: true);
          default:
            return const SizedBox.shrink();
        }
      case UserType.business:
        switch (index) {
          case 0:
            return HomeStoreScreen(
              businessAccountId: context.read<GlobalCubit>().businessId,
              isVendor: true,
            );
          case 1:
            return BlocProvider(
              create: (context) => StatisticsCubit(sl<StatisticsRepo>())
                ..fetchStatistics(context.read<GlobalCubit>().businessId),
              child: const DashboardScreen(),
            );
          case 2:
            return BlocProvider(
              create: (context) => NotificationsCubit(sl<NotificationsRepo>()),
              child: const NotificationsPage(),
            );
          case 3:
            return const MenuScreen(isVendor: true);
          default:
            return const SizedBox.shrink();
        }
    }
  }

  List<BottomNavigationBarItem> _navBarItems(
      BuildContext context, UserType userType) {
    switch (userType) {
      case UserType.client:
        return [
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/home.svg",
              labelKey: 'nav_home'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/cart.svg",
              labelKey: 'nav_cart'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/shop.svg",
              labelKey: '',
              isCenterItem: true,
              iconSize: 40.0),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/notification.svg",
              labelKey: 'nav_notification'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/menu.svg",
              labelKey: 'nav_menu'),
        ];
      case UserType.business:
        return [
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/home.svg",
              labelKey: 'nav_home'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/data_info.svg",
              labelKey: 'nav_info'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/notification.svg",
              labelKey: 'nav_notification'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/menu.svg",
              labelKey: 'nav_menu'),
        ];
      case UserType.store:
        return [
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/home.svg",
              labelKey: 'nav_home'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/cart.svg",
              labelKey: 'nav_cart'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/notification.svg",
              labelKey: 'nav_notification'),
          buildNavBarItem(
              context: context,
              iconPath: "assets/images/svg/nav/menu.svg",
              labelKey: 'nav_menu'),
        ];
    }
  }

  void _handleGuestNavigation(int index, BuildContext context) {
    if (index == 1 || index == 3 || index == 4) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('login_required'.tr(context)),
          content: Text('please_login_to_access_feature'.tr(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr(context)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                navigateToLogin(context);
              },
              child: Text('login'.tr(context)),
            ),
          ],
        ),
      );
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _onItemTapped(int index) {
    final globalCubit = context.read<GlobalCubit>();
    if (widget.isGuest == true) {
      _handleGuestNavigation(index, context);
      return;
    }
    globalCubit.changeBottomNavIndex(index); // Update via GlobalCubit
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        final globalCubit = context.read<GlobalCubit>();
        final userType = globalCubit.userType ?? UserType.client;
        final navBarItems = _navBarItems(context, userType);

        return Scaffold(
          body: _buildScreen(globalCubit.currentNavIndex,
              userType), // Build only the selected screen
          bottomNavigationBar: BottomNavigationBar(
            items: navBarItems,
            currentIndex:
                globalCubit.currentNavIndex, // Use GlobalCubit's index
            selectedItemColor: const Color(0xFF1565C0),
            unselectedItemColor: const Color(0xFF9DB2CE),
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 10,
            selectedFontSize: 10.sp,
            unselectedFontSize: 10.sp,
            showSelectedLabels: true,
            showUnselectedLabels: false,
          ),
        );
      },
    );
  }
}
