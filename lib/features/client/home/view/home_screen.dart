import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/cart/view/cubit/cart_state.dart';
import 'package:embone/features/client/chat/view/massages_screen.dart';
import 'package:embone/features/client/home/data/repo/home_repo.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';
import 'package:embone/features/client/home/view/widgets/tab_content_widgets.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:embone/features/client/search/view/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartCubit(sl<CartRepo>()),
      child: BlocProvider(
        create: (context) => HomeCubit(sl<HomeRepo>())..init(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final cubit = context.read<HomeCubit>();
            context.read<CartCubit>();
            final isRtl = context.read<GlobalCubit>().language == "ar";

            // Determine which tabs to show based on data availability
            final hasProducts = cubit.homeModel?.accounts.any(
                  (account) => account.products.isNotEmpty,
                ) ??
                false;
            final hasServices = cubit.services.isNotEmpty;
            final tabLength = (hasProducts && hasServices) ? 2 : 1;

            // Define tabs and tab views dynamically
            final tabs = <Widget>[];
            final tabViews = <Widget>[];

            if (hasProducts) {
              tabs.add(
                Tab(
                  child: Text(
                    "product".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
              tabViews.add(
                RefreshIndicator(
                  onRefresh: () async {
                    await cubit.fetchHomeData();
                  },
                  child: ProductTabContent(cubit: cubit, state: state),
                ),
              );
            }

            if (hasServices) {
              tabs.add(
                Tab(
                  child: Text(
                    "service".tr(context),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
              tabViews.add(
                RefreshIndicator(
                  onRefresh: () async {
                    await cubit.fetchServices();
                  },
                  child: ServiceTabContent(cubit: cubit, state: state),
                ),
              );
            }

            // If no tabs are available, show a fallback UI
            if (tabs.isEmpty) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Center(
                    child: Text(
                      "no_data_available".tr(context),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              );
            }

            return DefaultTabController(
              length: tabLength,
              child: BlocListener<GlobalCubit, GlobalState>(
                listener: (context, globalState) {
                  if (globalState is WishlistSuccess) {
                    showToast(
                      context,
                      message: globalState.message,
                      state: ToastStates.success,
                    );
                  }
                },
                child: BlocListener<CartCubit, CartState>(
                  listener: (context, cartState) {
                    if (cartState is AddToCartSuccess) {
                      showToast(
                        context,
                        message: cartState.message.tr(context),
                        state: ToastStates.success,
                      );
                    } else if (cartState is CartError) {
                      showToast(
                        context,
                        message: cartState.error.tr(context),
                        state: ToastStates.error,
                      );
                    }
                  },
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: Column(
                        children: [
                          AppHeader(
                            title: "menu".tr(context),
                            centerTitle: false,
                            showLogo: true,
                            leadingPosition: isRtl
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            alignment: HeaderAlignment.spaceBetween,
                            titleStyle: TextStyle(fontSize: 20.sp),
                            showBackButton: false,
                            style: HeaderStyle.standard,
                            leading: Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.chat_bubble_text,
                                    size: 28.h,
                                    color: const Color(0xff000000),
                                  ),
                                  onPressed: () {
                                    navigateTo(context, const MassagesScreen());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    CupertinoIcons.search,
                                    size: 28.h,
                                    color: const Color(0xff000000),
                                  ),
                                  onPressed: () {
                                    navigateTo(
                                      context,
                                      BlocProvider(
                                        create: (context) =>
                                            SearchCubit(sl<SearchRepo>())
                                              ..init(),
                                        child: const SearchPage(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.h),
                          if (tabs.length >
                              1) // Only show TabBar if multiple tabs
                            Container(
                              height: 60.h,
                              padding: EdgeInsets.all(0.w),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                              ),
                              child: TabBar(
                                tabs: tabs,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black87,
                                indicator: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(0.r),
                                ),
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                              ),
                            ),
                          SizedBox(height: 10.h),
                          Expanded(
                            child: tabs.length > 1
                                ? TabBarView(children: tabViews)
                                : tabViews.first,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
