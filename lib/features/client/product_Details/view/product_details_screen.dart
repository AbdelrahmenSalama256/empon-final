import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/inventory_button.dart';
import 'package:embone/features/client/product_Details/view/widgets/price_display.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_addtocart.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_color_option.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_description.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_image.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_info.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_quantity.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_share_bar.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_shipping_info.dart';
import 'package:embone/features/client/product_Details/view/widgets/review_section.dart';
import 'package:embone/features/client/product_Details/view/widgets/section_title.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class ProductDetailPage extends StatefulWidget {
  final bool isVendor;
  final int productId;

  const ProductDetailPage({
    super.key,
    this.isVendor = false,
    required this.productId,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedColorIndex = 1;
  int _quantity = 1;
  bool _isLoadingMoreTriggered = false; // Prevents multiple load more calls

  void _onColorSelected(int index) {
    setState(() {
      _selectedColorIndex = index;
    });
  }

  void _onQuantityChanged(int newQuantity) {
    setState(() {
      _quantity = newQuantity;
    });
  }

  @override
  void initState() {
    super.initState();
    context
        .read<SearchCubit>()
        .goToProduct(id: widget.productId)
        .whenComplete(() {
      context
          .read<SearchCubit>()
          .fetchReleatedProducts(id: widget.productId)
          .whenComplete(() {
        context
            .read<SearchCubit>()
            .fetchParentComments(productId: widget.productId);
      });
    });
  }

  List<Map<String, dynamic>> _convertCommentsToMap(
      List<CommentModel> comments) {
    return comments.map((comment) {
      return {
        'commentId': comment.commentId,
        'avatar': comment.userImage ?? 'assets/images/placholder.jpg',
        'name': comment.userName,
        'date': comment.time,
        'comment': comment.comment,
        'likes': comment.likesCount,
        'isLiked': comment.isLiked,
        'replies': comment.replies
                ?.map((reply) => {
                      'commentId': reply.commentId,
                      'avatar':
                          reply.userImage ?? 'assets/images/placholder.jpg',
                      'name': reply.userName,
                      'date': reply.time,
                      'comment': reply.comment,
                      'likes': reply.likesCount,
                      'isLiked': reply.isLiked,
                    })
                .toList() ??
            [],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";
    final ScrollController scrollController = ScrollController();
    final GlobalKey reviewSectionKey = GlobalKey();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, searchState) {
            final cubit = context.read<SearchCubit>();
            final product = cubit.productModel?.data;
            final relatedProducts = cubit.homeModel?.products ?? [];
            final productsHasMore = cubit.productsHasMore;

            _convertCommentsToMap(cubit.commentResponse?.data.comments ?? []);

            final availableColors = product?.variations
                    ?.map((v) => Color(int.parse(
                        v.color?.code?.replaceFirst('#', '0xff') ??
                            '0xff000000')))
                    .toSet()
                    .toList() ??
                [];

            final sizes = product?.variations
                    ?.map((v) => v.attributeValue?.name ?? '')
                    .toSet()
                    .toList() ??
                [];

            return BlocBuilder<GlobalCubit, GlobalState>(
              builder: (context, state) {
                return Column(
                  children: [
                    AppHeader(
                      title: 'product_details'.tr(context),
                      centerTitle: true,
                      onBackPressed: () => Navigator.pop(context),
                    ),
                    searchState is GoToProductLoading
                        ? const Expanded(
                            child: Center(child: CustomLoadingIndicator()))
                        : product?.id == null
                            ? Expanded(
                                child: Center(
                                  child: Text(
                                    'product_not_found'.tr(context),
                                    style: TextStyle(
                                        fontSize: 30.sp, color: Colors.grey),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 16.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ProductImageSection(
                                        images: [
                                          product?.image ?? '',
                                          ...(product?.images
                                                      ?.map((img) => img.url) ??
                                                  [])
                                              .where((url) =>
                                                  url?.isNotEmpty ?? false)
                                              .map((url) => url ?? ''),
                                        ],
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 4),
                                      ),
                                      SizedBox(height: 15.h),
                                      InteractionBar(
                                        isVendor: widget.isVendor,
                                        likeCount: product?.likes ?? 0,
                                        onEdit: () {
                                          navigateTo(
                                            context,
                                            AddProductPage(
                                              businessAccountId: int.parse(
                                                sl<CacheHelper>().getData(
                                                  key: AppConstants
                                                      .businessAccountId,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onDelete: () => CustomPopup.show(
                                          context: context,
                                          type: PopupType.alert,
                                          title: 'delete_product'.tr(context),
                                          titleColor: const Color(0xffEC4B4B),
                                          message: 'confirmation_message'
                                              .tr(context),
                                          primaryButtonText: "yes".tr(context),
                                          secondaryButtonText: "no".tr(context),
                                          onPrimaryButtonPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                        ),
                                        commentCount:
                                            cubit.commentResponse?.total ?? 0,
                                        onShare: () {
                                          final productId =
                                              cubit.productModel?.data?.id ?? 0;
                                          final productName =
                                              cubit.productModel?.data?.name ??
                                                  "Product";
                                          final deepLink =
                                              "myapp://product/$productId";

                                          Share.share(
                                            "Check out this product: $productName\n$deepLink",
                                            subject:
                                                "Awesome Product on Our App",
                                          );
                                        },
                                        onLike: () {
                                          context
                                              .read<GlobalCubit>()
                                              .addProductToWishlist(cubit
                                                      .productModel?.data?.id ??
                                                  0);
                                        },
                                        onComment: () {
                                          final context =
                                              reviewSectionKey.currentContext;
                                          if (context != null) {
                                            Scrollable.ensureVisible(
                                              context,
                                              duration: const Duration(
                                                  milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          }
                                        },
                                        onThumbsUp: () {
                                          cubit.toggleProductLike(
                                            productId:
                                                cubit.productModel?.data?.id ??
                                                    0,
                                          );
                                        },
                                      ),
                                      SizedBox(height: 15.h),
                                      if (widget.isVendor)
                                        InventoryButton(onPressed: () {}),
                                      SizedBox(height: 15.h),
                                      availableColors.isEmpty
                                          ? const SizedBox.shrink()
                                          : ColorOptionsSection(
                                              availableColors:
                                                  availableColors.isNotEmpty
                                                      ? availableColors
                                                      : [Colors.grey],
                                              selectedColorIndex:
                                                  _selectedColorIndex,
                                              onColorSelected: _onColorSelected,
                                            ),
                                      SizedBox(height: 15.h),
                                      PriceDisplay(
                                        currency: "currency".tr(context),
                                        currentPrice: double.tryParse(
                                                product?.price ?? '0') ??
                                            0.0,
                                        originalPrice: product?.isSale == 1.0
                                            ? (double.tryParse(product?.price ??
                                                        '0') ??
                                                    0.0) *
                                                1.5
                                            : null,
                                      ),
                                      SizedBox(height: 15.h),
                                      ProductInfoSection(
                                        name:
                                            product?.name ?? 'Unknown Product',
                                        price: double.tryParse(
                                                product?.price ?? '0') ??
                                            0.0,
                                        currency: "currency".tr(context),
                                        sellerName: product?.vendorName ??
                                            'Unknown Seller',
                                        productId: product?.code ?? 'N/A',
                                        sizes: sizes,
                                      ),
                                      SizedBox(height: 10.h),
                                      product?.id == null
                                          ? const SizedBox.shrink()
                                          : QuantitySelectorSection(
                                              isVendor: widget.isVendor,
                                              quantity: _quantity,
                                              onQuantityChanged:
                                                  _onQuantityChanged,
                                            ),
                                      SizedBox(height: 15.h),
                                      ReviewsSection(
                                        key: reviewSectionKey,
                                        reviews: cubit.comments,
                                        commentController:
                                            cubit.commentController,
                                        isVendor: widget.isVendor,
                                        cubit: cubit,
                                        productId: widget.productId,
                                      ),
                                      SizedBox(height: 15.h),
                                      ShippingInfoSection(
                                        startDate:
                                            product?.shippingStartDate ?? 'N/A',
                                        endDate:
                                            product?.shippingEndDate ?? 'N/A',
                                        price: product?.shippingPrice ?? 'N/A',
                                        origin: product?.vendorName ??
                                            'Unknown Origin',
                                      ),
                                      SizedBox(height: 15.h),
                                      if (!widget.isVendor)
                                        BlocProvider(
                                          create: (context) =>
                                              CartCubit(sl<CartRepo>()),
                                          child: AddToCartButton(
                                            productId: widget.productId,
                                            quantity: _quantity,
                                            variationId: 6,
                                          ),
                                        ),
                                      SizedBox(height: 15.h),
                                      ProductDescriptionSection(
                                        description: product?.description ??
                                            'No description available.',
                                      ),
                                      SizedBox(height: 15.h),
                                      if (!widget.isVendor)
                                        Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xffF6F6F6)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SectionTitle(
                                                title: 'related_products'
                                                    .tr(context),
                                                titleSize: 16.sp,
                                                verticalPadding: 15.h,
                                              ),
                                              SizedBox(height: 8.h),
                                              BlocBuilder<SearchCubit,
                                                  SearchState>(
                                                builder: (context, state) {
                                                  if (state
                                                      is RelatedProductsLoading) {
                                                    return SizedBox(
                                                      height: 350.h,
                                                      child: const Center(
                                                          child:
                                                              CustomLoadingIndicator()),
                                                    );
                                                  }

                                                  if (state
                                                      is RelatedProductsError) {
                                                    return SizedBox(
                                                      height: 350.h,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              state.message,
                                                              style: TextStyle(
                                                                fontSize: 16.sp,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            TextButton(
                                                              onPressed: () => cubit
                                                                  .fetchReleatedProducts(
                                                                      id: widget
                                                                          .productId),
                                                              child: Text(
                                                                  'retry'.tr(
                                                                      context)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  if (relatedProducts.isEmpty) {
                                                    return SizedBox(
                                                      height: 350.h,
                                                      child: Center(
                                                        child: Text(
                                                          'no_related_products'
                                                              .tr(context),
                                                          style: TextStyle(
                                                              fontSize: 16.sp,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    );
                                                  }

                                                  return SizedBox(
                                                    height: 350.h,
                                                    child: NotificationListener<
                                                        ScrollNotification>(
                                                      onNotification:
                                                          (ScrollNotification
                                                              scrollInfo) {
                                                        if (!_isLoadingMoreTriggered &&
                                                            productsHasMore &&
                                                            scrollInfo
                                                                is ScrollEndNotification &&
                                                            scrollInfo.metrics
                                                                    .pixels >=
                                                                scrollInfo
                                                                        .metrics
                                                                        .maxScrollExtent *
                                                                    0.9) {
                                                          setState(() {
                                                            _isLoadingMoreTriggered =
                                                                true;
                                                          });
                                                          cubit
                                                              .fetchReleatedProducts(
                                                                  id: widget
                                                                      .productId,
                                                                  loadMore:
                                                                      true)
                                                              .then((_) {
                                                            setState(() {
                                                              _isLoadingMoreTriggered =
                                                                  false;
                                                            });
                                                          });
                                                        }
                                                        return false;
                                                      },
                                                      child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        reverse: isRTL,
                                                        itemCount:
                                                            relatedProducts
                                                                    .length +
                                                                (productsHasMore
                                                                    ? 1
                                                                    : 0),
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (index ==
                                                                  relatedProducts
                                                                      .length &&
                                                              productsHasMore) {
                                                            return SizedBox(
                                                              width: 100.w,
                                                              child: const Center(
                                                                  child:
                                                                      CustomLoadingIndicator()),
                                                            );
                                                          }

                                                          final product =
                                                              relatedProducts[
                                                                  index];
                                                          return ProductCard(
                                                            imageUrl:
                                                                product.image,
                                                            title: product.name,
                                                            price: double.parse(
                                                                product.price),
                                                            badge: '',
                                                            actionText:
                                                                'shop_now'.tr(
                                                                    context),
                                                            isFavorite:
                                                                product.isLiked,
                                                            onFavoriteToggle:
                                                                () {
                                                              // Implement favorite toggle logic
                                                              context
                                                                  .read<
                                                                      GlobalCubit>()
                                                                  .addProductToWishlist(
                                                                      product
                                                                          .id);
                                                            },
                                                            onActionTap: () {},
                                                            onCardTap: () {
                                                              navigateTo(
                                                                context,
                                                                ProductDetailPage(
                                                                  isVendor: widget
                                                                      .isVendor,
                                                                  productId:
                                                                      product
                                                                          .id,
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      SizedBox(height: 10.h),
                                    ],
                                  ),
                                ),
                              ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
