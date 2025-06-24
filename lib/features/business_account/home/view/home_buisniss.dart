import 'package:embone/core/cubit/global_cubit.dart';
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
                    child: RefreshIndicator(
                      onRefresh: () async {
                        accountCubit.fetchBusinessAccount(businessAccountId ??
                            context.read<GlobalCubit>().businessId ??
                            0);
                      },
                      child: state is BusinessAccountError
                          ? Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                    color: Colors.red, fontSize: 16),
                              ),
                            )
                          : HomeStoreContent(
                              businessAccountCubit: accountCubit,
                              isVendor: isVendor ?? false,
                              id: businessAccountId ??
                                  context.read<GlobalCubit>().businessId ??
                                  0),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
