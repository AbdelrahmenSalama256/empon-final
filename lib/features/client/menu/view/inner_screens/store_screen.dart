import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_desc.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_logo.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/store_video_grid_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountId = int.parse(
        sl<CacheHelper>().getData(key: AppConstants.businessAccountId));
    final cubit = context.read<GlobalCubit>();
    int index =
        cubit.userAccount?.indexWhere((element) => element.id == accountId) ??
            -1;

    final accountData = index != -1 ? cubit.userAccount![index] : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store header with back button using AppHeader
            AppHeader(
              title: accountData!.name ?? 'store_name'.tr(context),
              showBackButton: true,
              centerTitle: true,
              style: HeaderStyle.standard,
            ),

            // Store content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      const StoreLogoAndImage(),

                      // const ActionButtonsRow(),
                      SizedBox(height: 16.h),

                      StoreDescription(
                        description: accountData.description!,
                        name: accountData.name!,
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 500.h,
                        child: const Expanded(child: StoreVideoGridImages()),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
