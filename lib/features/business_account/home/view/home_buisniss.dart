import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/empty_massage.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_content.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStoreScreen extends StatelessWidget {
  final int? businessAccountId;
  final String? businessAccountname;
  final bool? isVendor;
  const HomeStoreScreen({
    super.key,
    this.businessAccountId,
    this.businessAccountname,
    this.isVendor = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => BusinessAccountCubit(sl<BusinessAccountRepo>())
          ..fetchBusinessAccount(
            businessAccountId ?? context.read<GlobalCubit>().businessId ?? 0,
          ),
        child: BlocListener<BusinessAccountCubit, BusinessAccountState>(
          listener: (context, businessState) {
            if (businessState is BusinessAccountError) {
              if (sl<GlobalCubit>().userType == UserType.business) {
                sl<GlobalCubit>().setUserType(UserType.client);
              sl<GlobalCubit>().changeBottomNavIndex(0);
              }

              showToast(
                context,
                message: 'unexpected_error'.tr(context),
                state: ToastStates.error,
              );
              Future.delayed(const Duration(milliseconds: 1000));
              showToast(
                context,
                message: businessState.message,
                state: ToastStates.error,
              );
            }
          },
          child: BlocBuilder<GlobalCubit, GlobalState>(
            builder: (context, globalState) {
              final globalCubit = context.read<GlobalCubit>();
              final accountCubit = context.read<BusinessAccountCubit>();

              return BlocListener<GlobalCubit, GlobalState>(
                listener: (context, globalState) {
                  if (globalState is FollowAccountSuccess) {
                    accountCubit.fetchBusinessAccount(
                      businessAccountId ?? globalCubit.businessId ?? 0,
                    );
                    showToast(
                      context,
                      message: globalState.message.tr(context),
                      state: ToastStates.success,
                    );
                  }
                  if (globalState is WishlistSuccess) {
                    accountCubit.fetchBusinessAccount(
                      businessAccountId ?? globalCubit.businessId ?? 0,
                    );
                    showToast(
                      context,
                      message: globalState.message.tr(context),
                      state: ToastStates.success,
                    );
                  }
                },
                child: SafeArea(
                  child: Column(
                    children: [
                      HomeStoreHeader(
                        isVendor: isVendor ?? false,
                        name: businessAccountname,
                        onBackPressed: () {
                          if (isVendor != true) Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<BusinessAccountCubit,
                            BusinessAccountState>(
                          builder: (context, businessState) {
                            return RefreshIndicator(
                              onRefresh: () async {
                                accountCubit.fetchBusinessAccount(
                                  businessAccountId ??
                                      globalCubit.businessId ??
                                      0,
                                );
                              },
                              child: businessState is BusinessAccountLoading
                                  ? const Center(
                                      child: CustomLoadingIndicator())
                                  : accountCubit.accountData?.data == null
                                      ? Center(
                                          child: EmptyMessageWidget(
                                            message:
                                                "no_data_found".tr(context),
                                          ),
                                        )

                                       :HomeStoreContent(
                                          // Remove the Expanded from HomeStoreContent
                                          globalCubit: globalCubit,
                                          businessAccountCubit: accountCubit,
                                          isVendor: isVendor,
                                          id: businessAccountId ??
                                              globalCubit.businessId ??
                                              0,
                                        ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
