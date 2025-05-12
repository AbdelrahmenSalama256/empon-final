import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
import 'package:embone/features/client/product_Details/data/model/comment_model.dart';
import 'package:embone/features/client/product_Details/view/widgets/contact_us_section.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    context.read<SearchCubit>().goToProduct(id: widget.productId);
  }

  List<Map<String, dynamic>> _convertCommentsToMap(
      List<CommentModel> comments) {
    return comments.map((comment) {
      return {
        'commentId': comment.commentId,
        'avatar': comment.userImage ??
            'assets/images/default_avatar.png', // Add default avatar
        'name': comment.userName,
        'date': comment.time,
        'comment': comment.comment,
        'likes': comment.likesCount,
        'isLiked': comment.isLiked,
        'replies': comment.replies
                ?.map((reply) => {
                      'commentId': reply.commentId,
                      'avatar':
                          reply.userImage ?? 'assets/images/default_avatar.png',
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            final cubit = context.read<SearchCubit>();
            final product = cubit.productModel?.data;

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

            return Column(
              children: [
                AppHeader(
                  title: 'product_details'.tr(context),
                  centerTitle: true,
                  onBackPressed: () => Navigator.pop(context),
                ),
                state is GoToProductLoading
                    ? const Expanded(
                        child: Center(child: CustomLoadingIndicator()))
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ProductImageSection(
                                images: [
                                  product?.image ?? '',
                                  ...(product?.images?.map((img) => img.url) ??
                                          [])
                                      .where((url) => url?.isNotEmpty ?? false)
                                      .map((url) => url ?? ''),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              InteractionBar(
                                isVendor: widget.isVendor,
                                likeCount: product?.likes ?? 0,
                                onEdit: () {
                                  navigateTo(context, const AddProductPage());
                                },
                                onDelete: () => CustomPopup.show(
                                  context: context,
                                  type: PopupType.alert,
                                  title: 'delete_product'.tr(context),
                                  titleColor: const Color(0xffEC4B4B),
                                  message: 'confirmation_message'.tr(context),
                                  primaryButtonText: "yes".tr(context),
                                  secondaryButtonText: "no".tr(context),
                                  onPrimaryButtonPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                commentCount: cubit.commentResponse?.total ?? 0,
                                onShare: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Share pressed')),
                                  );
                                },
                                onLike: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Like pressed')),
                                  );
                                },
                                onComment: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Comment pressed')),
                                  );
                                },
                                onThumbsUp: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Thumbs up pressed')),
                                  );
                                },
                              ),
                              SizedBox(height: 15.h),
                              if (widget.isVendor)
                                InventoryButton(
                                  onPressed: () {},
                                ),
                              SizedBox(height: 15.h),
                              ColorOptionsSection(
                                availableColors: availableColors.isNotEmpty
                                    ? availableColors
                                    : [Colors.grey],
                                selectedColorIndex: _selectedColorIndex,
                                onColorSelected: _onColorSelected,
                              ),
                              SizedBox(height: 15.h),
                              PriceDisplay(
                                currency: "",
                                currentPrice:
                                    double.tryParse(product?.price ?? '0') ??
                                        0.0,
                                originalPrice: product?.isSale == 1.0
                                    ? (double.tryParse(product?.price ?? '0') ??
                                            0.0) *
                                        1.5
                                    : null,
                              ),
                              SizedBox(height: 15.h),
                              ProductInfoSection(
                                name: product?.name ?? 'Unknown Product',
                                price: double.tryParse(product?.price ?? '0') ??
                                    0.0,
                                currency: "EGP",
                                sellerName:
                                    product?.vendorName ?? 'Unknown Seller',
                                productId: product?.code ?? 'N/A',
                                sizes: sizes,
                              ),
                              SizedBox(height: 10.h),
                              QuantitySelectorSection(
                                isVendor: widget.isVendor,
                                quantity: _quantity,
                                onQuantityChanged: _onQuantityChanged,
                              ),
                              SizedBox(height: 15.h),
                              // In your ProductDetailPage build method where you use ReviewsSection:
                              ReviewsSection(
                                reviews: cubit.comments,
                                commentController: cubit.commentController,
                                isVendor: widget.isVendor,
                                cubit: cubit,
                                productId: widget.productId,
                              ),
                              SizedBox(height: 15.h),
                              ShippingInfoSection(
                                startDate: "1 مارس",
                                endDate: "3 مارس",
                                price: "2500",
                                origin: product?.vendorName ?? 'Unknown Origin',
                              ),
                              SizedBox(height: 15.h),
                              if (!widget.isVendor) const AddToCartButton(),
                              SizedBox(height: 15.h),
                              ProductDescriptionSection(
                                description: product?.description ??
                                    'No description available.',
                              ),
                              SizedBox(height: 15.h),
                              if (!widget.isVendor)
                                ContactForm(
                                  onSubmit: (email) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Email submitted: $email')),
                                    );
                                  },
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
                                        title: 'related_products'.tr(context),
                                        titleSize: 16.sp,
                                        verticalPadding: 15.h,
                                      ),
                                      SizedBox(height: 8.h),
                                      SizedBox(
                                        height: 350.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          reverse: isRTL,
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
                                              onCardTap: () {
                                                navigateTo(
                                                    context,
                                                    ProductDetailPage(
                                                        isVendor:
                                                            widget.isVendor,
                                                        productId: 22));
                                              },
                                            );
                                          },
                                        ),
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
        ),
      ),
    );
  }
}
