import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/business_account/product/view/update_product_buisniss_account.dart';
import 'package:embone/features/business_account/store/view/product_inventory_screen.dart';
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
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/cubit/search_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../data/model/product_variation.dart'
    as pv; // Use alias to resolve ambiguity

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
  int _selectedColorIndex = 1; // Start with index 1 (adjust based on data)
  String? _selectedSize; // Track selected size
  int _quantity = 1;
  bool _isLoadingMoreTriggered = false; // Prevents multiple load more calls

  void _onColorSelected(int index) {
    setState(() {
      _selectedColorIndex = index;
      _selectedSize = null; // Reset size when color changes
    });
    final cubit = context.read<SearchCubit>();
    final product = cubit.productModel?.data;
    if (product?.variations != null &&
        index >= 0 &&
        index < product!.variations!.length) {
      final colorId = product.variations![index].color?.id;
      if (colorId != null) {
        // Log selection (avoid print in production)
        if (kDebugMode) {
          debugPrint('Selected color index: $index, colorId: $colorId');
        }
        cubit.fetchVariations(productId: widget.productId, colorId: colorId);
      }
    }
  }

  void _onSizeSelected(String size) {
    setState(() {
      _selectedSize = size;
    });
  }

  void _onQuantityChanged(int newQuantity) {
    setState(() {
      final maxStock = _getAvailableStock();
      _quantity = newQuantity.clamp(1, maxStock > 0 ? maxStock : 1);
      if (_quantity > maxStock && maxStock > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Maximum stock ($maxStock) reached')),
        );
      }
    });
  }

  int _getAvailableStock() {
    final cubit = context.read<SearchCubit>();
    final variation = cubit.variations?.firstWhere(
      (v) => v.attributeValue.name == _selectedSize,
      orElse: () =>
          cubit.variations?.firstOrNull ??
          pv.ProductVariation(
              id: 0,
              name: '',
              price: '0',
              stock: 0,
              attributeValue: pv.AttributeValue(id: 0, name: ''),
              color: pv.ColorDetail(id: 0, name: '', code: '')),
    );
    return variation?.stock ?? 0;
  }

  pv.ProductVariation _getSelectedVariation() {
    // Ensure non-nullable return by providing a default
    final cubit = context.read<SearchCubit>();
    return cubit.variations?.firstWhere(
          (v) => v.attributeValue.name == _selectedSize,
          orElse: () =>
              cubit.variations?.firstOrNull ??
              pv.ProductVariation(
                  id: 0,
                  name: '',
                  price: '0',
                  stock: 0,
                  attributeValue: pv.AttributeValue(id: 0, name: ''),
                  color: pv.ColorDetail(id: 0, name: '', code: '')),
        ) ??
        pv.ProductVariation(
            id: 0,
            name: '',
            price: '0',
            stock: 0,
            attributeValue: pv.AttributeValue(id: 0, name: ''),
            color: pv.ColorDetail(id: 0, name: '', code: ''));
  }

  Color? _getSelectedColor() {
    final cubit = context.read<SearchCubit>();
    final product = cubit.productModel?.data;
    if (product?.variations != null &&
        _selectedColorIndex >= 0 &&
        _selectedColorIndex < product!.variations!.length) {
      return Color(int.parse(product
              .variations![_selectedColorIndex].color?.code
              ?.replaceFirst('#', '0xff') ??
          '0xff000000'));
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SearchCubit>();
    cubit.goToProduct(id: widget.productId).whenComplete(() {
      cubit.fetchReleatedProducts(id: widget.productId).whenComplete(() {
        cubit.fetchParentComments(productId: widget.productId);
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

            final sizes = cubit.variations
                    ?.map((v) => v.attributeValue.name)
                    .where((name) => name.isNotEmpty)
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
                                child: EmptyMessageWidget(
                                  message: 'product_not_found'.tr(context),
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
                                        commentCount:
                                            product?.commentCount ?? 0,
                                        isLoved: product?.isLoved ?? false,
                                        isThumbsUp: product?.isLiked ?? false,
                                        isActive: product?.active ?? 1,
                                        avatarUrls: const [], // Populate if needed
                                        onShare: () {
                                          final productId = product?.id ?? 0;
                                          final productName =
                                              product?.name ?? "Product";
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
                                              .addProductToWishlist(
                                                  product?.id ?? 0);
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
                                              productId: product?.id ?? 0);
                                        },
                                        onEdit: () {
                                          navigateTo(
                                            context,
                                            UpdateProductPage(
                                              businessAccountId: int.parse(
                                                  sl<CacheHelper>().getData(
                                                      key: AppConstants
                                                          .businessAccountId)),
                                              isService: false,
                                              productData: cubit.productModel,
                                            ),
                                          );
                                        },
                                        onDelete: () {
                                          CustomPopup.show(
                                            context: context,
                                            type: PopupType.alert,
                                            title: 'delete_product'.tr(context),
                                            titleColor: const Color(0xffEC4B4B),
                                            message: 'confirmation_message'
                                                .tr(context),
                                            primaryButtonText:
                                                "yes".tr(context),
                                            secondaryButtonText:
                                                "no".tr(context),
                                            onPrimaryButtonPressed: () async {
                                              Navigator.of(context)
                                                  .pop(); // Close popup
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => const Center(
                                                    child:
                                                        CustomLoadingIndicator()),
                                              );
                                              final productIdToDelete =
                                                  product?.id;
                                              try {
                                                await cubit.deleteProduct(
                                                    productIdToDelete ?? 0);
                                                Navigator.of(context, rootNavigator: true)
                                                    .pop(); 
                                                showToast(
                                                  context,
                                                  message:
                                                      'product_deleted_successfully'
                                                          .tr(context),
                                                  state: ToastStates.success,
                                                );
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const HomeStoreScreen(isVendor: true,)),
                                                  (route) => false,
                                                );
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              } catch (e) {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop(); // Close loading
                                                showToast(
                                                  context,
                                                  message: 'delete_failed'
                                                      .tr(context),
                                                  state: ToastStates.error,
                                                );
                                              }
                                            },
                                          );
                                        },

                                        onActive: () {
                                          cubit.updateProductStatus(
                                              product?.id ?? 0);
                                        },
                                      ),
                                      SizedBox(height: 15.h),
                                      if (widget.isVendor)
                                        InventoryButton(onPressed: () {
                                          navigateTo(
                                            context,
                                            BlocProvider(
                                              create: (context) =>
                                                  SearchCubit(sl<SearchRepo>())
                                                    ..goToProduct(
                                                        id: cubit.productModel!
                                                            .data!.id!),
                                              child:
                                                  const ProductInventoryScreen(),
                                            ),
                                          );
                                        }),
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
                                      if (searchState is VariationsLoading)
                                        Column(
                                          children: [
                                            SizedBox(height: 15.h),
                                            const Center(
                                                child:
                                                    LinearProgressIndicator()),
                                          ],
                                        )
                                      else
                                        PriceDisplay(
                                          currency: "currency".tr(context),
                                          currentPrice: double.tryParse(
                                                  _getSelectedVariation()
                                                      .price) ??
                                              0.0,
                                          originalPrice: product?.isSale == 1
                                              ? (double.tryParse(
                                                          product?.price ??
                                                              '0') ??
                                                      0.0) *
                                                  1.5
                                              : null,
                                        ),
                                      SizedBox(height: 15.h),
                                      if (searchState is VariationsLoading)
                                        Column(
                                          children: [
                                            SizedBox(height: 15.h),
                                            const Center(
                                                child:
                                                    LinearProgressIndicator()),
                                          ],
                                        )
                                      else
                                        ProductInfoSection(
                                          name: product?.name ??
                                              'Unknown Product',
                                          price: double.tryParse(
                                                  _getSelectedVariation()
                                                      .price) ??
                                              0.0,
                                          currency: "currency".tr(context),
                                          sellerName: product?.vendorName ??
                                              'Unknown Seller',
                                          productId: product?.code ?? 'N/A',
                                          type: product?.accountType,
                                          sizes: sizes,
                                          onSizeSelected: (selectedSize) {
                                            _onSizeSelected(selectedSize);
                                          },
                                        ),
                                      SizedBox(height: 10.h),
                                      product?.id == null
                                          ? const SizedBox.shrink()
                                          : (searchState is VariationsLoading)
                                              ? Column(
                                                  children: [
                                                    SizedBox(height: 15.h),
                                                    const Center(
                                                        child:
                                                            LinearProgressIndicator()),
                                                  ],
                                                )
                                              : QuantitySelectorSection(
                                                  isVendor: widget.isVendor,
                                                  quantity: _quantity,
                                                  maxQuantity:
                                                      _getAvailableStock(),
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
                                          child: (searchState
                                                  is VariationsLoading)
                                              ? const Center(
                                                  child:
                                                      CustomLoadingIndicator())
                                              : AddToCartButton(
                                                  productId: widget.productId,
                                                  imageUrl: product?.image,
                                                  productName: product?.name,
                                                  quantity: _quantity,
                                                  phone: product?.whastappNum,
                                                  variationId:
                                                      _getSelectedVariation()
                                                          .id,
                                                  type:
                                                      "${product?.accountType}",
                                                  selectedSize: _selectedSize,
                                                  selectedColor:
                                                      _getSelectedColor(),
                                                ),
                                        ),
                                      SizedBox(height: 15.h),
                                      ProductDescriptionSection(
                                        description: product?.description ??
                                            'No description available.',
                                        productData: product,
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
                                                                  fontSize:
                                                                      16.sp,
                                                                  color: Colors
                                                                      .red),
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
                                                                        CustomLoadingIndicator()));
                                                          }
                                                          final product =
                                                              relatedProducts[
                                                                  index];
                                                          return ProductCard(
                                                            imageUrl:
                                                                "${product.image}",
                                                            title:
                                                                "${product.name}",
                                                            price: double.parse(
                                                                "${product.price}"),
                                                            badge: '',
                                                            actionText:
                                                                'shop_now'.tr(
                                                                    context),
                                                            isFavorite: product
                                                                    .isFavourited ??
                                                                false,
                                                            onFavoriteToggle:
                                                                () {
                                                              context
                                                                  .read<
                                                                      GlobalCubit>()
                                                                  .addProductToWishlist(
                                                                      product.id ??
                                                                          0);
                                                            },
                                                            onActionTap: () {},
                                                            onCardTap: () {
                                                              navigateTo(
                                                                context,
                                                                BlocProvider(
                                                                  create: (context) =>
                                                                      SearchCubit(
                                                                          sl<SearchRepo>()),
                                                                  child: ProductDetailPage(
                                                                      isVendor:
                                                                          widget
                                                                              .isVendor,
                                                                      productId:
                                                                          product.id ??
                                                                              0),
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
