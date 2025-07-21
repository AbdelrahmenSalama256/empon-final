import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/home/view/widgets/section_header_home.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/shop/data/model/shop_response_model.dart';
import 'package:embone/features/client/shop/data/repo/shop_repo.dart';
import 'package:embone/features/client/shop/view/cubit/shop_cubit.dart';
import 'package:embone/features/client/shop/view/cubit/shop_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/categories_filter.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<AccountModel> _filterAccounts(ShopCubit cubit, String category) {
    return cubit.shopData?.data?.categories
            ?.where((categoryModel) => categoryModel.category?.name == category)
            .expand<AccountModel>(
                (categoryModel) => categoryModel.accounts ?? [])
            .toList() ??
        [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit(sl<ShopRepo>()),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: BlocBuilder<ShopCubit, ShopState>(
            builder: (context, state) {
              final cubit = context.read<ShopCubit>();
              final filteredAccounts =
                  _filterAccounts(cubit, cubit.selectedCategory);
              return Column(
                children: [
                  AppHeader(
                    title: "nearby_places".tr(context),
                    centerTitle: true,
                    showBackButton: true,
                    onBackPressed: () {
                      context.read<GlobalCubit>().changeBottomNavIndex(0);
                    },
                  ),
                  state is ShopLoading
                      ? Expanded(
                          child: Center(
                          child: SingleChildScrollView(
                            child: RefreshIndicator(
                                onRefresh: () async {
                                  cubit.init();
                                },
                                child: const Center(
                                    child: CustomLoadingIndicator())),
                          ),
                        ))
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              cubit.init();
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10.h),
                                  CategoriesFilter(
                                    cubit: cubit,
                                    selectedCategory: cubit.selectedCategory,
                                    onCategorySelected: (category) {
                                      cubit.updateCategory(category);
                                      setState(() {});
                                    },
                                  ),
                                  SizedBox(height: 10.h),
                                  Column(
                                    children: filteredAccounts.isEmpty
                                        ? [
                                            SizedBox(
                                              height: 200.h,
                                              child: Center(
                                                child: Text(
                                                  "no_products_found"
                                                      .tr(context),
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                        : filteredAccounts.map((account) {
                                            return Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10.h),
                                              child: _buildSection(
                                                context: context,
                                                title: account.name ?? '',
                                                imageUrl: account.image ?? '',
                                                products:
                                                    account.products ?? [],
                                              ),
                                            );
                                          }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String imageUrl,
    required List<ProductModel> products,
  }) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xffF6F6F6)),
      child: Column(
        children: [
          SectionHeader(
            backgroundColor: const Color(0xffF6F6F6),
            title: title,
            isNetworkImage: true,
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
                  imageUrl: product.imageUrl ?? '',
                  title: product.name ?? '',
                  price: double.tryParse(product.price ?? '0.0') ?? 0.0,
                  badge: '',
                  actionText: 'shop_now'.tr(context),
                  isFavorite: product.isFavourite ?? false,
                  onFavoriteToggle: () {
                    // Add product to wishlist using GlobalCubit
                    context
                        .read<GlobalCubit>()
                        .addProductToWishlist(product.id ?? 0);
                  },
                  onActionTap: () {
                    navigateTo(
                      context,
                      BlocProvider(
                        create: (context) => SearchCubit(sl<SearchRepo>()),
                        child: ProductDetailPage(
                          productId: product.id ?? 0,
                        ),
                      ),
                    );
                  },
                  onCardTap: () {
                    navigateTo(
                      context,
                      BlocProvider(
                        create: (context) => SearchCubit(sl<SearchRepo>()),
                        child: ProductDetailPage(
                          productId: product.id ?? 0,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
