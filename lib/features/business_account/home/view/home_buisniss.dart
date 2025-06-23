import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_content.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:embone/features/business_account/product/data/repo/product_repo.dart';
import 'package:embone/features/business_account/product/data/repo/service_repo.dart';
import 'package:embone/features/business_account/product/view/cubit/product_cubit.dart';
import 'package:embone/features/business_account/product/view/cubit/service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStoreScreen extends StatelessWidget {
  const HomeStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId = int.parse(
        sl<CacheHelper>().getData(key: AppConstants.businessAccountId));
    PrintUtil.success('Business ID: $accountId');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HomeStoreHeader(
              onBackPressed: () {
                // context.read<GlobalCubit>().setUserType(UserType.client);
                // context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
            ),
            Expanded(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => ServiceCubit(sl<ServiceRepo>())
                      ..getServicesByAccountId(),
                  ),
                  BlocProvider(
                    create: (context) => ProductCubit(sl<ProductRepo>())
                      ..getProductsByAccountId(accountId),
                  ),
                  BlocProvider(
                    create: (context) => BusinessAccountCubit(sl<BusinessAccountRepo>())
                      ..fetchBusinessAccount(accountId),
                    )
                ],
                child:BlocBuilder<BusinessAccountCubit, BusinessAccountState>(
      builder: (context, state) {
        return state is BusinessAccountLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            : HomeStoreContent(id: accountId);})
              ),
            ),
          ],
        ),
      ),
    );
  }
}
