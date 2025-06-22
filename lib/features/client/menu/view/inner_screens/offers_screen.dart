import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: "special_offers".tr(context),
              onBackPressed: () => Navigator.pop(context),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: SvgPicture.asset(
                    "assets/images/svg/search.svg",
                    width: 24.w,
                    height: 24.h,
                  ),
                  onPressed: () {
                    navigateTo(
                      context,
                      BlocProvider(
                        create: (context) =>
                            SearchCubit(sl<SearchRepo>())..init(),
                        child: const SearchPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: _buildOffersGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOffersGrid() {
    final offers = _getAllOffers();

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(),
        childAspectRatio: _getChildAspectRatio(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
      ),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return ProductCard(
          imageUrl: offer['imageUrl'],
          title: offer['title'],
          isOffer: true,
          price: offer['price'],
          originalPrice: offer['originalPrice'],
          badge: offer['badge'],
          actionText: offer['actionText'],
          isFavorite: offer['isFavorite'],
          discountPercentage: offer['discount'],
          onFavoriteToggle: () {
            setState(() {
              offers[index]['isFavorite'] = !offers[index]['isFavorite'];
            });
          },
          onActionTap: () {
            _handleAddToCart(offer);
          },
          onCardTap: () {
            _handleProductTap(offer);
          },
        );
      },
    );
  }

  int _getCrossAxisCount() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 3; // Tablet
    } else if (screenWidth > 400) {
      return 2; // Large phone
    } else {
      return 1; // Small phone
    }
  }

  double _getChildAspectRatio() {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return 0.75;
    } else if (screenWidth > 400) {
      return 0.8;
    } else {
      return 0.85;
    }
  }

  List<Map<String, dynamic>> _getAllOffers() {
    return [
      {
        'id': '1',
        'imageUrl':
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        'title': 'nike_air_max_270'.tr(context),
        'price': 89.99,
        'originalPrice': 129.99,
        'badge': 'flash_sale'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': false,
        'discount': 30,
      },
      {
        'id': '2',
        'imageUrl':
            'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
        'title': 'adidas_ultraboost'.tr(context),
        'price': 119.99,
        'originalPrice': 159.99,
        'badge': 'limited_offer'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': true,
        'discount': 25,
      },
      {
        'id': '3',
        'imageUrl':
            'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
        'title': 'puma_rs_x'.tr(context),
        'price': 79.99,
        'originalPrice': 99.99,
        'badge': 'new_arrival'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': false,
        'discount': 20,
      },
      {
        'id': '4',
        'imageUrl':
            'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=400',
        'title': 'converse_chuck_taylor'.tr(context),
        'price': 49.99,
        'originalPrice': 69.99,
        'badge': 'best_seller'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': false,
        'discount': 28,
      },
      {
        'id': '5',
        'imageUrl':
            'https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2?w=400',
        'title': 'vans_old_skool'.tr(context),
        'price': 54.99,
        'originalPrice': 74.99,
        'badge': 'hot_deal'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': true,
        'discount': 27,
      },
      {
        'id': '6',
        'imageUrl':
            'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
        'title': 'jordan_air_1'.tr(context),
        'price': 139.99,
        'originalPrice': 179.99,
        'badge': 'exclusive'.tr(context),
        'actionText': 'add_to_cart'.tr(context),
        'isFavorite': false,
        'discount': 22,
      },
    ];
  }

  void _handleAddToCart(Map<String, dynamic> offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${offer['title']} ${"added_to_cart".tr(context)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleProductTap(Map<String, dynamic> offer) {
    // Navigate to product details
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(productId: offer['id'])));
  }
}
