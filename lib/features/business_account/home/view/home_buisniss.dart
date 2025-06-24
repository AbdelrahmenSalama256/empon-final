import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_content.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStoreScreen extends StatelessWidget {
  final int? businessAccountId;
  final bool? isVendor;
  const HomeStoreScreen(
      {super.key, this.businessAccountId, this.isVendor = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => BusinessAccountCubit(sl<BusinessAccountRepo>())
          ..fetchBusinessAccount(
            businessAccountId ?? context.read<GlobalCubit>().businessId ?? 0,
          ),
        child: BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
          builder: (context, state) {
            final accountCubit = context.read<BusinessAccountCubit>();
            return BlocListener<BusinessAccountCubit, BusinessAccountState>(
              listener: (context, state) {
                if (state is BusinessAccountError) {
                  showToast(context,
                      message: state.message, state: ToastStates.error);
                }
              },
              child: BlocBuilder<GlobalCubit, GlobalState>(
                builder: (context, globalState) {
                  final globalCubit = context.read<GlobalCubit>();
                  return SafeArea(
                    child: Column(
                      children: [
                        HomeStoreHeader(
                          isVendor: isVendor ?? false,
                          name: accountCubit.accountData?.name,
                          onBackPressed: () {
                            // context.read<GlobalCubit>().setUserType(UserType.client);
                            // context.read<GlobalCubit>().changeBottomNavIndex(0);
                            isVendor != true ? Navigator.pop(context) : null;
                          },
                        ),
                        Expanded(
                          child: state is BusinessAccountLoading
                              ? const Center(
                                  child: CustomLoadingIndicator(),
                                )
                              : HomeStoreContent(
                                  globalCubit: globalCubit,
                                  businessAccountCubit: accountCubit,
                                  isVendor: isVendor,
                                  id: businessAccountId ??
                                      context.read<GlobalCubit>().businessId ??
                                      0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
