import 'package:embone/core/component/widgets/skeleton_loader.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/home_buisniss.dart';
import 'package:embone/features/client/home/view/cubit/home_cubit.dart';
import 'package:embone/features/client/home/view/cubit/home_state.dart';
import 'package:embone/features/client/home/view/widgets/services_card.dart';
import 'package:embone/features/client/product_Details/view/service_detailes_secreen.dart';
import 'package:embone/features/client/search/data/repo/search_repo.dart';
import 'package:embone/features/client/search/view/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceTabContent extends StatefulWidget {
  final HomeCubit cubit;
  final HomeState state;

  const ServiceTabContent(
      {super.key, required this.cubit, required this.state});

  @override
  State<ServiceTabContent> createState() => _ServiceTabContentState();
}

class _ServiceTabContentState extends State<ServiceTabContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7) {
      if (!widget.cubit.servicesIsLoadingMore && widget.cubit.servicesHasMore) {
        widget.cubit.loadMoreServices();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state is HomeLoading && widget.cubit.services.isEmpty) {
      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: 3,
        itemBuilder: (context, index) {
          return ShimmerEffect(
            isLoading: true,
            child: Column(
              children: [
                SkeletonLoader(
                  width: double.infinity,
                  height: 40.h,
                  borderRadius: 8.0,
                  margin: EdgeInsets.only(bottom: 10.h),
                ),
                SizedBox(
                  height: 360.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, itemIndex) {
                      return SkeletonLoader(
                        width: 200.w,
                        height: 300.h,
                        borderRadius: 12.0,
                        margin: EdgeInsets.all(10.w),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      );
    }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollDetails) {
            // This is a fallback; _onScroll handles the main logic
            return false;
          },
          child: ListView.builder(
            controller: _scrollController,
            key: const PageStorageKey<String>("service"),
            padding: EdgeInsets.only(bottom: 0.h, left: 0.w, right: 0.w),
            itemCount: widget.cubit.services.length +
                (widget.cubit.servicesIsLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.cubit.services.length &&
                  widget.cubit.servicesIsLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (widget.cubit.services.isEmpty) {
                return Center(child: Text('no_services'.tr(context)));
              }
              final service = widget.cubit.services[index];
              return ServiceCard(
                service: service,
                onBrandTap: () {
                  PrintUtil.debug("Account tapped: ${service.account?.name}");
                  navigateTo(
                      context,
                      HomeStoreScreen(
                        businessAccountId: service.account?.id,
                        isVendor: false,
                      ));
                },
                onTap: () {
                  PrintUtil.debug("Service tapped: ${service.name}");
                  PrintUtil.debug("Service tapped: ${service.id}");
                  navigateTo(
                      context,
                      BlocProvider(
                        create: (context) => SearchCubit(sl<SearchRepo>()),
                        child: ServiceDetailPage(
                          isVendor: false,
                          serviceId: service.id ?? 0,
                        ),
                      ));
                },
              );
            },
          ),
        );
      },
    );
  }
}
