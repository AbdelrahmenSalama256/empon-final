import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/store/view/product_inventory_screen.dart';
import 'package:embone/features/client/product_Details/view/widgets/product_details_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductDetailVendorPage extends StatefulWidget {
  const ProductDetailVendorPage({super.key});

  @override
  State<ProductDetailVendorPage> createState() =>
      _ProductDetailVendorPageState();
}

class _ProductDetailVendorPageState extends State<ProductDetailVendorPage> {
  bool _isAvailable = true;
  int _selectedSizeIndex = 3;

  final List<Color> _availableColors = [
    AppColors.primary,
    Colors.black,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.grey,
  ];

  final List<String> _sizes = ['37', '38', '39', '40', '41', '42'];

  final List<Map<String, dynamic>> _comments = [
    {
      'name': 'منار محمد',
      'avatar': 'https://randomuser.me/api/portraits/women/32.jpg',
      'comment': 'كم سعر هذا المنتج وما هي المقاسات المتاحة',
      'date': '14 min',
      'likes': 2,
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
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            AppHeader(
              title: "product_details".tr(context),
              centerTitle: true,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image
                    const ProductImageSection(),

                    // Interaction Bar
                    _buildInteractionBar(),

                    // Available Quantities Button
                    _buildAvailableQuantitiesButton(),

                    // Product Info
                    _buildProductInfo(),

                    // Size Selection
                    _buildSizeSelection(),

                    // Comments Section
                    _buildCommentsSection(),

                    // Comment Input
                    _buildCommentInput(),

                    // Shipping Info
                    _buildShippingInfo(),

                    // Product Specifications
                    _buildProductSpecifications(),

                    SizedBox(height: 80.h), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // Dots and Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Availability toggle
              Row(
                children: [
                  Text(
                    'متوفر',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  CupertinoSwitch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeTrackColor: AppColors.primary,
                  ),
                ],
              ),

              // Action buttons
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateTo(context, const ProductInventoryScreen());
                    },
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color: const Color(0xffE6E6E6), width: 1.5.w),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        CupertinoIcons.pencil,
                        color: Colors.black,
                        size: 20.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEC4B4B),
                      border: Border.all(
                          color: const Color(0xffE6E6E6), width: 1.5.w),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Image.asset(
                      "assets/images/trash.png",
                      width: 16.w,
                      height: 16.h,
                      // fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Comments and Likes count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Comments count
              Row(
                children: [
                  Icon(Icons.comment_outlined, size: 20.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    'عدد التعليقات: 25',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),

              // Likes count
              Row(
                children: [
                  Icon(Icons.thumb_up_outlined,
                      size: 20.sp, color: Colors.grey),
                  SizedBox(width: 4.w),
                  Text(
                    'عدد الإعجابات: 75',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableQuantitiesButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: AppButton(
        text: 'الاعداد المتاحة من المنتج',
        onPressed: () {
          navigateTo(context, const ProductInventoryScreen());
        },
        prefixIcon: Icon(Icons.grid_view, size: 20.sp, color: Colors.white),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info Title
          Text(
            'معلومات عن المنتج',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          // Available Colors
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الألوان المتاحة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: _availableColors.map((color) {
                  return Container(
                    margin: EdgeInsetsDirectional.only(start: 8.w),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Price
          Row(
            children: [
              Icon(Icons.favorite_border, size: 20.sp, color: Colors.red),
              SizedBox(width: 8.w),
              Text(
                '6800',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'جنيه',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                '10250',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'جنيه',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Seller Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'البائع:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'نيكسي ستايل',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Serial Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'رقم التسلسل:',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '8744 8748 857',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر المقاس:',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),

          // Sizes
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(_sizes.length, (index) {
              final isSelected = index == _selectedSizeIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSizeIndex = index;
                  });
                },
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  margin: EdgeInsetsDirectional.only(start: 8.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          isSelected ? AppColors.primary : Colors.grey.shade300,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                    color: isSelected
                        // ignore: deprecated_member_use
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      _sizes[index],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 16.h),

          // Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'العدد:',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '30',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Divider(height: 1.h, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التعليقات',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          // Comments list
          Column(
            children: _comments.map((comment) {
              return _buildCommentItem(comment);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.shade100,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment['name'],
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      comment['date'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Comment text
                Text(
                  comment['comment'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),

                // Like and reply
                Row(
                  children: [
                    Icon(CupertinoIcons.hand_thumbsup,
                        size: 16.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      'الإعجابات ${comment['likes']}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(Icons.reply, size: 16.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      'رد',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقك هنا',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon:
                  const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
              onPressed: () {},
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                'ارسل',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات عن الشحن',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow('الوقت التقريبي للوصول للشحنة', 'من 3 إلى 5 أيام'),
          _buildInfoRow('التوصيل المجاني', 'للطلبات بأكثر من 2500 جنيه'),
          _buildInfoRow('سياسة الشحن', 'شحن مجاني للطلبات المجمعة'),
          _buildInfoRow('المستهلكين', 'جميع المنتجات من تركيا'),
          SizedBox(height: 16.h),
          Divider(height: 1.h, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  Widget _buildProductSpecifications() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات عن المنتج',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),

          _buildSpecRow('المادة الخارجية', 'صناعي 100%'),
          _buildSpecRow('البطانة', 'صناعي 100%'),
          _buildSpecRow('النعل', 'صناعي 100%'),

          // See more button
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'اقرأ المزيد ...',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
