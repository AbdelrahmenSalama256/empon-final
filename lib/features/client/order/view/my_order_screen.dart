import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/order/data/repo/orders_repo.dart';
import 'package:embone/features/client/order/view/cubit/orders_cubit.dart';
import 'package:embone/features/client/order/view/cubit/orders_state.dart';
import 'package:embone/features/client/order/view/widgets/order_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>context.read<GlobalCubit>().userType == UserType.client? (OrdersCubit(sl<OrderRepo>())..fetchOrders()): (OrdersCubit(sl<OrderRepo>())..fetchAccountOrders()),
      child: BlocConsumer<OrdersCubit, OrdersState>(
        listener: (context, state) {
          if (state is OrderCanceled) {
            showToast(
              context,
              message: state.message.tr(context),
              state: ToastStates.success,
            );
          } else if (state is OrderError) {
            showToast(
              context,
              message: 'unexpected_error'.tr(context),
              state: ToastStates.error,
            );
          }
          else if (state is OrderUpdateError) {
            showToast(
              context,
              message: state.message,
              state: ToastStates.error,
            );
          }
          if (state is OrderUpdateLoaded) {
            context.read<OrdersCubit>()..fetchAccountOrders();
          }
        },
        builder: (context, state) {
          debugPrint(
              'MyOrdersScreen rebuilt with state: $state'); // Debug rebuild
          final cubit = context.read<OrdersCubit>();
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  AppHeader(
                    title: 'my_orders'.tr(context),
                    centerTitle: true,
                    showBackButton: true,
                    onBackPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      labelColor: AppColors.white,
                      unselectedLabelColor: const Color(0xff152354),
                      indicator: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      dividerColor: Colors.transparent,
                      dividerHeight: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 7.h),
                      tabs: [
                        Tab(
                          child: Text(
                            "all".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Poppins",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "delivered".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Poppins",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "pending".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Poppins",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "canceled".tr(context),
                            style: TextStyle(
                              fontFamily:
                                  context.read<GlobalCubit>().language == "ar"
                                      ? 'Beiruti'
                                      : "Poppins",
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ModalProgressHUD(
                      inAsyncCall: state is OrderLoading,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          cubit.fetchOrders();
                        },
                        child: Container(
                          color: Colors.black.withOpacity(0.1),
                          child: TabBarView(
                            controller: _tabController,
                            children: const [
                              OrdersList(
                                key: ValueKey('all'),
                                status: "all",
                                statusColor: Color(0xffFFA500),
                                showCancelButton: false,
                              ),
                              OrdersList(
                                key: ValueKey('delivered'),
                                status: "delivered",
                                statusColor: Color(0xff64B95C),
                                showCancelButton: false,
                              ),
                              OrdersList(
                                key: ValueKey('pending'),
                                status: "pending",
                                statusColor: AppColors.primary,
                                showCancelButton: true,
                              ),
                              OrdersList(
                                key: ValueKey('cancelled'),
                                status: "cancelled",
                                statusColor: Color(0xffEC4B4B),
                                showCancelButton: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
