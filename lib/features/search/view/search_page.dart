import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/auth/view/widgets/auth_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Mock data for recently viewed items
  final List<Map<String, dynamic>> _recentlyViewed = [
    {
      'id': 1,
      'image': 'assets/images/test-product.png',
      'name': 'black_shirt',
    },
    {
      'id': 2,
      'image': 'assets/images/test-product-1.png',
      'name': 'red_shoes',
    },
    {
      'id': 3,
      'image': 'assets/images/test-product.png',
      'name': 'womens_perfume',
    },
    {
      'id': 4,
      'image': 'assets/images/test-product-1.png',
      'name': 'sports_shoe',
    },
  ];

  // Mock data for recent searches
  final List<String> _recentSearches = [
    'sports_shoe',
    'womens_perfume',
  ];

  @override
  void initState() {
    super.initState();
    // Automatically focus the search field when the page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Handle search
      print('Searching for: $query');
      // In a real app, you would navigate to a search results page
      // or update the current page with results
    }
  }

  void _onRecentItemTap(int id) {
    // Handle tapping on a recently viewed item
    final item = _recentlyViewed.firstWhere((item) => item['id'] == id);
    print('Tapped on recently viewed item: ${item['name']}');
    // In a real app, you would navigate to the product details page
  }

  void _onRecentSearchTap(String query) {
    // Set the search controller text to the tapped query
    _searchController.text = query;
    // Perform search
    _onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header with back button and title
              _buildHeader(),

              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    _buildSearchBar(),

                    SizedBox(height: 24.h),

                    // Recently viewed section
                    _buildRecentlyViewedSection(),

                    SizedBox(height: 24.h),

                    // Recent searches section
                    _buildRecentSearchesSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return AppHeader(
      title: 'search'.tr(context),
      showBackButton: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      style: HeaderStyle.standard,
      height: 80.h,
    );
  }

  Widget _buildSearchBar() {
    return Material(
      color: Colors.transparent,
      child: AppTextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        hintText: 'search'.tr(context),
        labelText: 'search'.tr(context),
        prefixIcon: Icon(
          CupertinoIcons.search,
          color: const Color(0xff8F95AB).withOpacity(0.7),
          size: 24.sp,
        ),
        onSubmitted: _onSearch,
      ),
    );
  }

  Widget _buildRecentlyViewedSection() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'recently_viewed'.tr(context),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),

        SizedBox(height: 12.h),

        // Recently viewed items grid
        SizedBox(
          height: 80.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // For RTL layout
            itemCount: _recentlyViewed.length,
            itemBuilder: (context, index) {
              final item = _recentlyViewed[index];
              return GestureDetector(
                onTap: () => _onRecentItemTap(item['id']),
                child: Container(
                  width: 80.w,
                  height: 80.w,
                  margin: EdgeInsets.only(left: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          size: 24.w,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearchesSection() {
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment:
          isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          'recent_searches'.tr(context),
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),

        SizedBox(height: 12.h),

        // Recent searches list
        Column(
          crossAxisAlignment:
              isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: _recentSearches.map((query) {
            return GestureDetector(
              onTap: () => _onRecentSearchTap(query),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  query,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
