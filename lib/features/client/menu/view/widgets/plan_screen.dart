import 'package:embone/core/constants/app_constant.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';
import 'package:embone/features/business_account/home/view/cubit/account_cubit.dart';
import 'package:embone/features/client/menu/data/repo/packages_repo.dart';
import 'package:embone/features/client/menu/view/cubit/packages_cubit.dart';
import 'package:embone/features/client/menu/view/widgets/grade_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlanSection extends StatefulWidget {
  const PlanSection({super.key});

  @override
  State<PlanSection> createState() => _PlanSectionState();
}

class _PlanSectionState extends State<PlanSection> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<PackagesCubit>();

    final cubit = context.read<GlobalCubit>();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'business_promotion_plans'.tr(context),
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < productCubit.packages.length; i++)
            _buildPlanTile(
              index: i,
              title: productCubit.packages[i].name,
              color: Colors.primaries[i % Colors.primaries.length],
              details: productCubit.packages[i].features,
              onPressed: () {
                navigateTo(
                  context,
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) =>
                            BusinessAccountCubit(sl<BusinessAccountRepo>())
                              ..fetchBusinessAccount(cubit.businessId ?? 0),
                      ),
                      BlocProvider(
                        create: (context) => PackagesCubit(sl<PackagesRepo>())..fetchCities()
                        )
                    ],
                    child:  SelectableGridScreen(
                      accountId: int.parse(sl<CacheHelper>()
                          .getData(key: AppConstants.businessAccountId)) ,
                      planId: productCubit.packages[i].id,

                    ),
                  ),
                );
                setState(() {
                  expandedIndex = i;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildPlanTile(
      {required int index,
      required String title,
      required Color color,
      required Map<String, String> details,
      required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ExpansionTile(
        collapsedIconColor: color,
        iconColor: color,
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        initiallyExpanded: expandedIndex == index,
        onExpansionChanged: (expanded) {
          if (expandedIndex != (expanded ? index : null)) {
            setState(() {
              expandedIndex = expanded ? index : null;
            });
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var entry in details.entries)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${entry.key}: ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: onPressed,
                    child:  Text("Select_Plan".tr(context)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
