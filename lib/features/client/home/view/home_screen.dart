import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/chat/view/massages_screen.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the ProductCards
    final List<Map<String, dynamic>> products = [
      {
        'imageUrl': 'assets/images/test-product.png',
        'title': 'حذاء رياضي',
        'price': 900.00,
        'badge': 'best_seller'.tr(context),
        'actionText': 'shop_now'.tr(context),
        'isFavorite': false,
      },
      {
        'imageUrl': 'assets/images/test-product-1.png',
        'title': 'حذاء رياضي',
        'price': 850.00,
        'badge': 'new'.tr(context),
        'actionText': 'shop_now'.tr(context),
        'isFavorite': false,
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // SizedBox(height: 16.h),
            AppHeader(
              title: "menu".tr(context),
              centerTitle: false,
              showLogo: true,
              leadingPosition: MainAxisAlignment.end,
              alignment: HeaderAlignment.spaceBetween,
              titleStyle: TextStyle(fontSize: 20.sp),
              showBackButton: false,
              style: HeaderStyle.standard,
              automaticallyImplyLeading: false,
              // padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 8.h),
              leading: Row(
                children: [
                  // Chat Icon
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.chat_bubble_text,
                      size: 28.h,
                      color: const Color(0xff000000),
                    ),
                    onPressed: () {
                      navigateTo(context, const MassagesScreen());
                    },
                  ),

                  // Search Icon
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

            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
                      child: Column(
                        children: [
                          SectionHeader(
                            backgroundColor: const Color(0xffF6F6F6),
                            title: "كومفرت شوز",
                            imageUrl: "assets/images/brand-logo.png",
                            subtitle: "sponsored".tr(context),
                            showCloseButton: true,
                            onClose: () {
                              context
                                  .read<GlobalCubit>()
                                  .changeBottomNavIndex(0);
                            },
                          ),
                          SizedBox(
                            height: 350.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  imageUrl: product['imageUrl'],
                                  title: product['title'],
                                  price: product['price'],
                                  badge: product['badge'],
                                  actionText: product['actionText'],
                                  isFavorite: product['isFavorite'],
                                  onFavoriteToggle: () {
                                    // Handle favorite toggle
                                  },
                                  onActionTap: () {
                                    // Handle action tap
                                  },
                                  onCardTap: () {
                                    navigateTo(
                                      context,
                                      const ProductDetailPage(),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
                      child: Column(
                        children: [
                          SectionHeader(
                            backgroundColor: const Color(0xffF6F6F6),
                            title: "بكسي ستايل",
                            imageUrl: "assets/images/brand-two.png",
                            subtitle: "sponsored".tr(context),
                            showCloseButton: true,
                            onClose: () {
                              context
                                  .read<GlobalCubit>()
                                  .changeBottomNavIndex(0);
                            },
                          ),
                          SizedBox(
                            height: 350.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  imageUrl: product['imageUrl'],
                                  title: product['title'],
                                  price: product['price'],
                                  badge: product['badge'],
                                  actionText: product['actionText'],
                                  isFavorite: product['isFavorite'],
                                  onFavoriteToggle: () {
                                    // Handle favorite toggle
                                  },
                                  onActionTap: () {
                                    // Handle action tap
                                  },
                                  onCardTap: () {
                                    navigateTo(
                                      context,
                                      const ProductDetailPage(),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
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
