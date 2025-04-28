import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/custom_popup.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/product/view/add_product_buisniss_account.dart';
import 'package:embone/features/client/home/view/widgets/product_card.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailPage extends StatefulWidget {
  final bool? isVendor;
  const ProductDetailPage({super.key, this.isVendor = false});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedColorIndex = 1;
  int _quantity = 1;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.green,
  ];
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'منار محمد',
      'avatar': 'https://randomuser.me/api/portraits/women/32.jpg',
      'comment': 'كم سعر هذا المنتج وما هي المقاسات المتاحة',
      'date': '14 min',
      'likes': 2,
      'replies': [
        {
          'id': '2',
          'parentId': '1',
          'name': 'User Two',
          'avatar': 'https://randomuser.me/api/portraits/women/32.jpg',
          'comment': 'Reply to comment 1',
          'date': '1 day ago',
          'likes': 2,
          'replies': [
            {
              'id': '2',
              'parentId': '1',
              'name': 'User Two',
              'avatar': 'https://randomuser.me/api/portraits/women/32.jpg',
              'comment': 'Reply to comment 1',
              'date': '1 day ago',
              'likes': 2,
              'replies': [],
            }
          ],
        }
      ],
    },
    {
      'name': 'نيكسي ستايل',
      'avatar': 'https://randomuser.me/api/portraits/men/41.jpg',
      'comment': 'كم سعر هذا المنتج وما هي المقاسات المتاحة',
      'date': '14 min',
      'likes': 2,
    },
    {
      'name': 'منار محمد',
      'avatar': 'https://randomuser.me/api/portraits/women/32.jpg',
      'comment': 'كم سعر هذا المنتج وما هي المقاسات المتاحة',
      'date': '14 min',
      'likes': 2,
      'replies': [
        {
          'name': 'نيكسي ستايل',
          'avatar': 'https://randomuser.me/api/portraits/men/41.jpg',
          'comment': 'السعر 6800 جنيه',
          'date': '10 min',
          'likes': 1,
          'replies': [
            {
              'name': 'نيكسي ستايل',
              'avatar': 'https://randomuser.me/api/portraits/men/41.jpg',
              'comment': 'السعر 6800 جنيه',
              'date': '10 min',
              'likes': 1,
              'replies': [],
            },
          ],
        },
      ],
    },
  ];

  void _addComment(String comment) {
    setState(() {
      _reviews.add({
        'name': 'أنت',
        'avatar': 'https://randomuser.me/api/portraits/men/1.jpg',
        'comment': comment,
        'date': 'الآن',
        'likes': 0,
      });
    });
  }

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
        child: Column(
          children: [
            // Header
            AppHeader(
              title: 'product_details'.tr(context),
              centerTitle: true,
              onBackPressed: () => Navigator.pop(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //! Product image and dots
                    const ProductImageSection(),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Animated interaction bar
                    InteractionBar(
                      isVendor: widget.isVendor ?? false,
                      likeCount: 124,
                      onEdit: () {
                        navigateTo(context, const AddProductPage());
                      },
                      onDelete: () => CustomPopup.show(
                        context: context,
                        type: PopupType.alert,
                        title: 'delete_product'.tr(context),
                        titleColor: const Color(0xffEC4B4B),
                        // icon: Container(),
                        message: 'confirmation_message'.tr(context),
                        primaryButtonText: "yes".tr(context),
                        secondaryButtonText: "no".tr(context),
                        onPrimaryButtonPressed: () {
                          // Handle deletion
                          Navigator.of(context).pop();
                        },
                      ),
                      commentCount: 32,
                      onShare: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Share pressed')),
                        );
                      },
                      onLike: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Like pressed')),
                        );
                      },
                      onComment: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment pressed')),
                        );
                      },
                      onThumbsUp: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Thumbs up pressed')),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    widget.isVendor != false
                        ? InventoryButton(
                            onPressed: () {},
                          )
                        : SizedBox(height: 0.h),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Color options
                    ColorOptionsSection(
                      availableColors: _availableColors,
                      selectedColorIndex: _selectedColorIndex,
                      onColorSelected: _onColorSelected,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    const PriceDisplay(
                      currentPrice: 6800,
                      originalPrice: 10250,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Product info
                    const ProductInfoSection(
                      name: "Product Name",
                      price: 99.99,
                      currency: "\$",
                      sellerName: "Test Seller",
                      productId: "1",
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    //! Quantity selector
                    QuantitySelectorSection(
                      isVendor: widget.isVendor,
                      quantity: _quantity,
                      onQuantityChanged: _onQuantityChanged,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Reviews
                    ReviewsSection(
                      isVendor: widget.isVendor,
                      reviews: _reviews,
                      onAddComment: _addComment,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Shipping Info
                    const ShippingInfoSection(),
                    SizedBox(
                      height: 15.h,
                    ),
                    //! Add to cart button
                    widget.isVendor != true
                        ? const AddToCartButton()
                        : SizedBox(height: 0.h),
                    //! Product description
                    const ProductDescriptionSection(
                      description:
                          "This is a sample product description. It provides details about the product, its features, and specifications.",
                    ),

                    //! Contact form
                    widget.isVendor != true
                        ? ContactForm(
                            onSubmit: (email) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Email submitted: $email')),
                              );
                            },
                          )
                        : SizedBox(height: 0.h),

                    //! Related products
                    widget.isVendor != true
                        ? Container(
                            decoration:
                                const BoxDecoration(color: Color(0xffF6F6F6)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section title
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
                                    reverse: isRTL, // Reverse scrolling for RTL
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
                          )
                        : SizedBox(height: 0.h),
                    SizedBox(height: 10.h),
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
