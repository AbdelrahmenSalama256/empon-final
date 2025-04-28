import 'package:embone/features/business_account/home/view/widgets/home_store_content.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:embone/core/cubit/global_cubit.dart';

class HomeStoreScreen extends StatelessWidget {
  const HomeStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const Expanded(
              child: HomeStoreContent(),
            ),
          ],
        ),
      ),
    );
  }
}
