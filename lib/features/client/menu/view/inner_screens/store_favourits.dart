import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/wishlist_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreFavourites extends StatefulWidget {
  const StoreFavourites({super.key});

  @override
  State<StoreFavourites> createState() => _StoreFavouritesState();
}

class _StoreFavouritesState extends State<StoreFavourites>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Sample wishlist items with translation keys
    final List<Map<String, dynamic>> wishlistItems = [
      {
        'nameKey': 'athletic_shoes',
        'price': 900.00,
        'brandKey': 'comfort_shoes',
        'brandLogo': 'assets/images/brand-logo.png',
        'image': 'assets/images/test-product.png',
        'isFavorite': true,
      },
      {
        'nameKey': 'womens_perfume',
        'price': 900.00,
        'brandKey': 'sephora',
        'brandLogo': 'assets/images/brand-logo.png',
        'image': 'assets/images/test-product-1.png',
        'isFavorite': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Store header with back button using AppHeader
            AppHeader(
              title: 'favorite_product'.tr(context),
              showBackButton: true,
              centerTitle: true,
              style: HeaderStyle.standard,
            ),
            // Tab Bar
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.white,
                unselectedLabelColor: const Color(0xff152354),
                indicator: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                dividerColor: Colors.transparent,
                dividerHeight: 0,
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                tabs: [
                  Tab(
                    child: Text(
                      "favorite_stores".tr(context),
                      style: TextStyle(
                        fontFamily: context.read<GlobalCubit>().language == "ar"
                            ? 'Beiruti'
                            : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "favorite_products".tr(context),
                      style: TextStyle(
                        fontFamily: context.read<GlobalCubit>().language == "ar"
                            ? 'Beiruti'
                            : "Poppins",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab Content
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Delivered Orders Tab
                  ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = wishlistItems[index];
                      return WishlistItemCard(
                        item: item,
                        isBrand: true,
                        onRemove: () {},
                        onToggleFavorite: () {},
                      );
                    },
                  ),
                  // Canceled Orders Tab
                  ListView.builder(
                    padding: EdgeInsets.all(16.w),
                    itemCount: wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = wishlistItems[index];
                      return WishlistItemCard(
                        item: item,
                        onRemove: () {},
                        onToggleFavorite: () {},
                      );
                    },
                  ),
                  // In Delivery Orders Tab
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
