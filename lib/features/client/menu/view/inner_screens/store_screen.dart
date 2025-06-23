import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/data/model/account_model.dart';
import 'package:embone/features/client/menu/data/repo/account_repo.dart';
import 'package:embone/features/client/menu/view/cubit/accounts_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/accounts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreProfileScreen extends StatefulWidget {
  final int accountId;

  const StoreProfileScreen({super.key, required this.accountId});

  @override
  State<StoreProfileScreen> createState() => _StoreProfileScreenState();
}

class _StoreProfileScreenState extends State<StoreProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AccountsCubit(sl<AccountsRepo>())..init(widget.accountId),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: SafeArea(
          child: BlocBuilder<AccountsCubit, AccountsState>(
            builder: (context, state) {
              final accountsCubit = context.read<AccountsCubit>();
              final account = accountsCubit.account?.data;

              return Column(
                children: [
                  // App Header
                  AppHeader(
                    title: account?.name,
                    showBackButton: true,
                    centerTitle: true,
                    style: HeaderStyle.standard,
                  ),
                  state is AccountLoading
                      ? const Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Store Cover and Profile Section
                                _buildStoreHeader(account!),
                                // Store Info Section
                                _buildStoreInfo(account),
                                // Action Buttons
                                _buildActionButtons(),
                                // Stats Section
                                _buildStatsSection(account),
                                // About Section
                                _buildAboutSection(account),
                                // Tabs Section
                                _buildTabsSection(account),
                              ],
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

  Widget _buildStoreHeader(Account account) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Cover Image
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  account.cover,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile Section
          Transform.translate(
            offset: Offset(0, -30.h),
            child: Column(
              children: [
                // Store Logo
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4.w),
                    image: DecorationImage(
                      image: NetworkImage(
                        account.logo,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Store Name with Verification
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      account.name,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    if (account.verified) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified,
                        color: Colors.blue,
                        size: 20.w,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                // Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey.shade600,
                      size: 16.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${account.city}, ${account.state}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
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

  Widget _buildStoreInfo(Account account) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        children: [
          if (account.phone != null) _buildInfoRow(Icons.phone, account.phone),
          if (account.email != null) _buildInfoRow(Icons.email, account.email),
          if (account.website != null)
            _buildInfoRow(Icons.language, "${account.website}"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.w,
            color: AppColors.primary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Handle follow action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'follow'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Handle message action
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'message'.tr(context),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              onPressed: () {
                // Handle share action
              },
              icon: Icon(
                Icons.share,
                color: AppColors.primary,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Account account) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'products'.tr(context),
            account.totalProducts.toString(),
          ),
          _buildStatItem(
            'services'.tr(context),
            account.totalServices.toString(),
          ),
          _buildStatItem(
            'followers'.tr(context),
            account.totalFollowers.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(Account account) {
    if (account.description.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(16.w),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'about'.tr(context),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            account.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsSection(Account account) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 8.h),
      child: Column(
        children: [
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.w,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.w,
              labelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              tabs: [
                Tab(
                  text: '${'products'.tr(context)} (${account.totalProducts})',
                ),
                Tab(
                  text: '${'services'.tr(context)} (${account.totalServices})',
                ),
              ],
            ),
          ),
          // Tab Views
          SizedBox(
            height: 400.h,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductsGrid(account.products),
                _buildServicesGrid(account.services),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState('no_products'.tr(context));
    }
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildImageCard(
          imageUrl: product.image,
          onTap: () {
            // Handle product tap
          },
        );
      },
    );
  }

  Widget _buildServicesGrid(List<Service> services) {
    if (services.isEmpty) {
      return _buildEmptyState('no_services'.tr(context));
    }
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildImageCard(
          imageUrl: service.mainImage,
          onTap: () {
            // Handle service tap
          },
        );
      },
    );
  }

  Widget _buildImageCard({
    required String? imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: imageUrl != null && imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                        strokeWidth: 2.w,
                        color: AppColors.primary,
                      ),
                    );
                  },
                )
              : _buildImagePlaceholder(),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 30.w,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48.w,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
