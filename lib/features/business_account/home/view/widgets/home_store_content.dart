import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/features/business_account/home/view/widgets/home_store_name_section.dart'
    show HomeStoreNameSection;
import 'package:embone/features/business_account/home/view/widgets/home_videos.dart';
import 'package:embone/features/client/product_Details/view/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home_store_hero.dart';
import 'home_store_followers.dart';
import 'home_store_products.dart';
import 'home_store_description.dart';

class HomeStoreContent extends StatelessWidget {
  int id;
  HomeStoreContent({super.key,required this.id});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<GlobalCubit>();
  int index =cubit.userAccount?.indexWhere((element) => element.id == id) ?? -1;

   final accountData = index != -1 ? cubit.userAccount![index] : null;
    //! todo :hanle this case account id not cashed
    PrintUtil.success(accountData!.name ?? 'No account data found');
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeStoreHero(),
          SizedBox(height: 16.h),
          const HomeStoreNameSection(),
          SizedBox(height: 16.h),
          const HomeStoreFollowers(),
          SizedBox(height: 16.h),
          const HomeStoreProducts(),
          SizedBox(height: 16.h),
          const HomeStoreDescription(),
          SizedBox(height: 20.h),
          SizedBox(
            height: 500.h,
            child: SingleChildScrollView(
              child: HomeVideoGridImages(
                videoUrl: 'https://example.com/custom-video.mp4',
                // ignore: avoid_print
                onProductTap: (index) => navigateTo(
                  context,
                  const ProductDetailPage(
                    isVendor: true,
                    productId: 0,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
