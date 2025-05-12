import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/widgets/recent_search_section.dart';
import 'package:embone/features/client/search/view/widgets/recently_viewd_section.dart';
import 'package:embone/features/client/search/view/widgets/search_results_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

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
      // Trigger search using SearchCubit
      context.read<SearchCubit>().search(query);
    }
  }

  void _onRecentSearchTap(String query) {
    // Set the search controller text to the tapped query
    _searchController.text = query;
    // Perform search
    _onSearch(query);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final searchModel = context.read<SearchCubit>().searchModel;
        final searchHistoryModel =
            context.read<SearchCubit>().searchHistoryModel;
        final cubit = context.read<SearchCubit>();
        return BlocListener<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchSuccess) {
              cubit.fetchSearchHistory();
            }
            if (state is DeleteSearchHistorySuccess) {
              showToast(context,
                  message: "deleted_success".tr(context),
                  state: ToastStates.success);
            }
            if (state is ClearHistorySuccess) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
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

                          //! Recently viewed section
                          RecentlyViewedSection(
                            recentlyViewed: cubit.recentViewModel?.items ?? [],
                            onItemTap: (p0) {
                              navigateTo(
                                  context,
                                  BlocProvider(
                                    create: (context) =>
                                        SearchCubit(sl<SearchRepo>()),
                                    child: ProductDetailPage(
                                      productId: p0,
                                    ),
                                  ));
                            },
                            onClearTap: () {
                              cubit.clearHistory();
                            },
                          ),

                          SizedBox(height: 24.h),

                          // Recent searches section
                          RecentSearchesSection(
                            recentSearches: searchHistoryModel?.history ?? [],
                            onSearchTap: _onRecentSearchTap,
                            onRemoveTap: (id) {
                              context
                                  .read<SearchCubit>()
                                  .deleteSearchHistory(id: id);
                            },
                          ),

                          state is SearchLoading
                              ? const Center(child: CircularProgressIndicator())
                              : searchModel != null &&
                                      searchModel.products.isNotEmpty
                                  ? SearchResultsSection(
                                      products: searchModel.products,
                                      onGoingTap: (id) {
                                        cubit.goToProduct(id: id);
                                      },
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'search_results'.tr(context),
                                          style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 16.h),
                                        Center(
                                          child: Text(
                                            "no_results".tr(context),
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return AppHeader(
      title: 'search'.tr(context),
      showBackButton: true,
      centerTitle: true,
      backgroundColor: Colors.white,
      style: HeaderStyle.standard,
      alignment: HeaderAlignment.center,
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
          // ignore: deprecated_member_use
          color: const Color(0xff8F95AB).withOpacity(0.7),
          size: 24.sp,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  setState(() {});
                },
                child: Icon(
                  CupertinoIcons.xmark,
                  color: const Color(0xff8F95AB).withOpacity(0.7),
                  size: 20.sp,
                ),
              )
            : null,
        onSubmitted: _onSearch,
      ),
    );
  }
}
