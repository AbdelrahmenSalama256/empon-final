import 'dart:developer';

import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/model/category_model.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/account_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/data/repo/category_repo.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/business_account_success_page.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/component/widgets/app_dropdown.dart';
import 'cubit/account_state.dart';
import 'cubit/category_state.dart';

class CreateBusinessAccountDetailsPage extends StatelessWidget {
  const CreateBusinessAccountDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            CategoryCubit(sl<CategoryRepo>())..fetchCategories(),
        child: BlocListener<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state is AccountStepOneCompleted) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => AccountCubit(sl<AccountRepo>()),
                    child: const BusinessAccountSuccessPage(),
                  ),
                ),
              );
            }
            if (state is AccountError) {
              log(state.massage);
              showToast(context,
                  message: 'unexpected_error'.tr(context),
                  state: ToastStates.error);
            }
          },
          child: BlocBuilder<AccountCubit, AccountState>(
              builder: (context, state) {
            final accountCubit = context.read<AccountCubit>();
            PrintUtil.debug(accountCubit.name);

            return Scaffold(
              backgroundColor: AppColors.white,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header
                    AppHeader(
                      title: 'create_business_account'.tr(context),
                      centerTitle: true,
                      showBackButton: true,
                      onBackPressed: () => Navigator.pop(context),
                      style: HeaderStyle.standard,
                    ),
                    SizedBox(height: 24.h),
                    // Business account title and description
                    Container(
                      margin: EdgeInsets.all(10.w),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xffF8F8F8),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  'business_account_title'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                // Subtitle
                                Text(
                                  'business_account_subtitle'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Description
                                Text(
                                  'business_account_description'.tr(context),
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SvgPicture.asset(
                            "assets/images/svg/create_bussins.svg",
                            width: 106.w,
                            height: 116.h,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: BlocConsumer<CategoryCubit, CategoryState>(
                          listener: (context, state) {},
                          builder: (context, categoryState) {
                            final categories = categoryState is CategoriesLoaded
                                ? categoryState.categories
                                : <CategoryModel>[];

                            if (accountCubit.categoryIds.isNotEmpty &&
                                categoryState is CategoriesLoaded) {
                              final selectedId = accountCubit.categoryIds.first;
                              categories.firstWhere(
                                (c) => c.id.toString() == selectedId,
                                orElse: () => const CategoryModel(
                                    id: -1,
                                    name: '',
                                    description: '',
                                    icon: ''),
                              );
                            }
                            if (state is CategoriesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Business account name section
                                Text(
                                  'business_account_name_question'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                // Subtitle
                                Text(
                                  'business_account_name_instructions'
                                      .tr(context),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff7C7C7C),
                                  ),
                                ),
                                SizedBox(height: 18.h),
                                // BlocConsumer<AccountCubit, AccountState>(
                                //   listener: (context, state) {
                                //     log(state.toString());
                                //   },
                                //   builder: (context, state) {
                                //     return CustomElevatedButton(
                                //       text: "test",
                                //       onPressed: () {
                                //         log("Test Button");
                                //         context.read<AccountCubit>().testState();
                                //       },
                                //     );
                                //   },
                                // ),

                                BlocConsumer<AccountCubit, AccountState>(
                                  listener: (context, state) {
                                    log(state.toString());
                                  },
                                  builder: (context, state) {
                                    if (categories.isEmpty) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return AppDropdownField(
                                      hint: 'category'.tr(context),
                                      onChanged: (value) {},
                                      selectedValues: categories
                                          .where((c) => accountCubit.categoryIds
                                              .contains(c.id.toString()))
                                          .map((c) => c.name)
                                          .toList(),
                                      isMultiSelect: true,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12.w, vertical: 12.h),
                                      items: categories
                                          .map((c) => c.name)
                                          .toList(),
                                      onMultipleChanged:
                                          (List<String> selectedNames) {
                                        final accountCubit =
                                            context.read<AccountCubit>();
                                        final newCategoryIds = <String>[];
                                        for (var name in selectedNames) {
                                          final selectedCategory =
                                              categories.firstWhere(
                                            (c) => c.name == name,
                                            orElse: () => const CategoryModel(
                                                id: -1,
                                                name: '',
                                                description: '',
                                                icon: ''),
                                          );
                                          if (selectedCategory.id != -1) {
                                            newCategoryIds.add(
                                                selectedCategory.id.toString());
                                          }
                                        }
                                        accountCubit
                                            .updateCategoryIds(newCategoryIds);
                                      },
                                      showErrorBorder: true,
                                    );
                                  },
                                ),
                                SizedBox(height: 18.h),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 24.h),
                                  child: Column(
                                    children: [
                                      AppButton(
                                        text: 'create_business_account'
                                            .tr(context),
                                        isLoading: state is AccountLoading,
                                        onPressed: () {
                                          if (state is! AccountLoading &&
                                              accountCubit
                                                  .categoryIds.isNotEmpty) {
                                            accountCubit.createAccountStepOne();
                                          } else {
                                            showToast(
                                              context,
                                              message: 'select_categories'
                                                  .tr(context),
                                              state: ToastStates.error,
                                            );
                                          }
                                        },
                                      ),
                                      if (state is AccountError)
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Text(
                                            state.massage,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      if (accountCubit.categoryIds.isEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(top: 8.h),
                                          child: Text(
                                            'select_categories'.tr(context),
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
