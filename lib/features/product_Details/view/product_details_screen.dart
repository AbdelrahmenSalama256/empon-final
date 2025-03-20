import 'package:embone/features/product_Details/view/widgets/product_details_addtocart.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_color_option.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_description.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_header.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_image.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_info.dart';
import 'package:embone/features/product_Details/view/widgets/product_details_quantity.dart';
import 'package:embone/features/product_Details/view/widgets/related_products_section.dart';
import 'package:embone/features/product_Details/view/widgets/review_section.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _selectedColorIndex = 1; // Blue is selected by default
  int _quantity = 1;
  bool _isFavorite = false;

  final List<Color> _availableColors = [
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.green,
  ];

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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            ProductDetailHeader(
              title: 'تفاصيل المنتج',
              onBackPressed: () => Navigator.pop(context),
              onSharePressed: () {},
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product image and dots
                    const ProductImageSection(),

                    // Color options
                    ColorOptionsSection(
                      availableColors: _availableColors,
                      selectedColorIndex: _selectedColorIndex,
                      onColorSelected: _onColorSelected,
                    ),

                    // Product info
                    const ProductInfoSection(
                      name: 'حذاء رياضي',
                      price: 599.00,
                      currency: 'ج.م',
                      selectedSize: '42',
                    ),

                    // Quantity selector
                    QuantitySelectorSection(
                      quantity: _quantity,
                      onQuantityChanged: _onQuantityChanged,
                    ),

                    // Add to cart button
                    const AddToCartButton(),

                    // Product description
                    const ProductDescriptionSection(
                      description:
                          'هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك أن تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى زيادة عدد الحروف التي يولدها التطبيق.',
                    ),

                    // Reviews
                    const ReviewsSection(
                      reviews: [
                        {
                          'name': 'محمد أحمد',
                          'avatar': 'assets/images/avatar1.png',
                          'rating': 5,
                          'comment': 'منتج رائع، أنصح به بشدة!',
                          'date': 'منذ 3 أيام',
                        },
                        {
                          'name': 'سارة محمود',
                          'avatar': 'assets/images/avatar2.png',
                          'rating': 4,
                          'comment':
                              'جودة ممتازة ولكن المقاس أصغر قليلاً من المتوقع.',
                          'date': 'منذ أسبوع',
                        },
                      ],
                    ),

                    // Related products
                    RelatedProductsSection(
                      products: List.generate(
                        3,
                        (index) => {
                          'image': 'assets/images/shoes1.png',
                          'name': 'حذاء رياضي',
                          'price': 599.00,
                          'currency': 'ج.م',
                        },
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
