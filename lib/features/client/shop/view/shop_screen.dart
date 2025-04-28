import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';

import 'widgets/categories_filter.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double? latitude;
  double? longitude;
  bool isLoading = true;
  final Location _location = Location();
  String selectedCategory = 'shoes'; // Default category

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => isLoading = true);

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          if (kDebugMode) print("Location services are not enabled");
          setState(() => isLoading = false);
          return;
        }
      }

      PermissionStatus permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();
        if (permissionStatus != PermissionStatus.granted) {
          if (kDebugMode) print("Location permissions are denied");
          setState(() => isLoading = false);
          return;
        }
      }

      LocationData locationData = await _location.getLocation();
      setState(() {
        latitude = locationData.latitude;
        longitude = locationData.longitude;
        isLoading = false;
      });

      if (kDebugMode) {
        print("Current Location: Lat: $latitude, Long: $longitude");
      }
    } catch (e) {
      if (kDebugMode) print("Error getting location: $e");
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> _filterProducts(String category) {
    final List<Map<String, dynamic>> allProducts = [
      {
        'imageUrl': 'assets/images/test-product.png',
        'title': 'Athletic Shoes',
        'price': 900.00,
        'badge': 'BEST SELLER',
        'actionText': 'SHOP NOW',
        'isFavorite': false,
        'category': 'shoes',
      },
      {
        'imageUrl': 'assets/images/test-product-1.png',
        'title': 'Running Shoes',
        'price': 850.00,
        'badge': 'NEW',
        'actionText': 'SHOP NOW',
        'isFavorite': false,
        'category': 'shoes',
      },
      // Add more products with different categories as needed
    ];

    return allProducts
        .where((product) => product['category'] == category)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _filterProducts(selectedCategory);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // SizedBox(height: 20.h),
            // _buildLocationIndicator(),
            AppHeader(
              title: "nearby_places".tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () {
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
            ),
            SizedBox(height: 10.h),
            CategoriesFilter(
              onCategorySelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSection(
                      title: "comfort_shoes".tr(context),
                      imageUrl: "assets/images/brand-logo.png",
                      products: filteredProducts,
                    ),
                    SizedBox(height: 10.h),
                    _buildSection(
                      title: "pixy_style".tr(context),
                      imageUrl: "assets/images/brand-two.png",
                      products: filteredProducts,
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

  // Widget _buildLocationIndicator() {
  //   if (isLoading) {
  //     return Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w),
  //       child: Row(
  //         children: [
  //           const Icon(Icons.location_on, color: Colors.grey),
  //           SizedBox(width: 8.w),
  //           Text(
  //             "getting_location".tr(context),
  //             style: const TextStyle(color: Colors.grey),
  //           ),
  //           const Spacer(),
  //           const SizedBox(
  //             width: 16,
  //             height: 16,
  //             child: CircularProgressIndicator(strokeWidth: 2),
  //           ),
  //         ],
  //       ),
  //     );
  //   } else if (latitude != null && longitude != null) {
  //     return Padding(
  //       padding: EdgeInsets.symmetric(horizontal: 16.w),
  //       child: Row(
  //         children: [
  //           const Icon(Icons.location_on, color: Colors.green),
  //           SizedBox(width: 8.w),
  //           Text(
  //             "Location: ${latitude!.toStringAsFixed(4)}, ${longitude!.toStringAsFixed(4)}",
  //             style: const TextStyle(color: Colors.green),
  //           ),
  //           const Spacer(),
  //           IconButton(
  //             icon: const Icon(Icons.refresh, size: 20),
  //             onPressed: _getCurrentLocation,
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }

  Widget _buildSection({
    required String title,
    required String imageUrl,
    required List<Map<String, dynamic>> products,
  }) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
      child: Column(
        children: [
          SectionHeader(
            backgroundColor: const Color(0xffF6F6F6),
            title: title,
            imageUrl: imageUrl,
            subtitle: "sponsored".tr(context),
            showCloseButton: true,
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
                  onFavoriteToggle: () {},
                  onActionTap: () {},
                  onCardTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
