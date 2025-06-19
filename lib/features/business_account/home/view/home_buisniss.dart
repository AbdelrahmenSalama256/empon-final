import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_content.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:embone/core/cubit/global_cubit.dart';

class HomeStoreScreen extends StatelessWidget {
  const HomeStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId= int.parse(sl<CacheHelper>().getData(key: AppConstants.businessAccountId));
    PrintUtil.success('Business ID: $accountId');
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HomeStoreHeader(
              onBackPressed: () {
                context.read<GlobalCubit>().setUserType(UserType.client);
                context.read<GlobalCubit>().changeBottomNavIndex(0);
              },
            ),
            Expanded(
              child: HomeStoreContent(id : accountId),
            ),
          ],
        ),
      ),
    );
  }
}
