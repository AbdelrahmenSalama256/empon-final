import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/menu/data/repo/wallet_repo.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widget/balance_card.dart';
import 'widget/transaction_item.dart';

class WalletSummaryScreen extends StatelessWidget {
  const WalletSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit(sl<WalletRepo>())..init(),
      child: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletLoaded) {
            showToast(
              context,
              message:
                  'Wallet balance updated: ${state.walletResponse.data.balance}',
              state: ToastStates.success,
            );
          } else if (state is WalletError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          } else if (state is WalletHistoryError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final cubit = context.read<WalletCubit>();
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    AppHeader(
                      title: 'wallet'.tr(context),
                      showBackButton: true,
                      centerTitle: true,
                      style: HeaderStyle.standard,
                    ),
                    SizedBox(height: 16.h),
                    state is WalletLoading || state is WalletHistoryLoading
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: Column(
                                children: [
                                  SizedBox(height: 16.h),
                                  BalanceCard(
                                    balance: cubit.balance,
                                    currency: 'egp'.tr(context),
                                  ),
                                  SizedBox(height: 16.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'recent_transactions'.tr(context),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff1E2644),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 16.h),
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: cubit.transactions.length,
                                    itemBuilder: (context, index) {
                                      final transaction =
                                          cubit.transactions[index];
                                      final isDeposit =
                                          transaction.type == 'add';
                                      return TransactionItem(
                                        amount: transaction.amount,
                                        isDeposit: isDeposit,
                                        description:
                                            transaction.type.tr(context),
                                        date: transaction.createdAt,
                                      );
                                    },
                                  )),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class WalletSummaryScreenWithStats extends StatelessWidget {
  const WalletSummaryScreenWithStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit(sl<WalletRepo>())..init(),
      child: BlocListener<WalletCubit, WalletState>(
        listener: (context, state) {
          if (state is WalletLoaded) {
            showToast(
              context,
              message:
                  'Wallet balance updated: ${state.walletResponse.data.balance}',
              state: ToastStates.success,
            );
          } else if (state is WalletError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          } else if (state is WalletHistoryError) {
            showToast(
              context,
              message: state.error,
              state: ToastStates.error,
            );
          }
        },
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final cubit = context.read<WalletCubit>();
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Column(
                  children: [
                    AppHeader(
                      title: 'wallet'.tr(context),
                      showBackButton: true,
                      centerTitle: true,
                      style: HeaderStyle.standard,
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            state is WalletLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : BalanceCard(
                                    balance: cubit.balance,
                                    currency: 'egp'.tr(context),
                                  ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'recent_transactions'.tr(context),
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff1E2644),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Expanded(
                              child: state is WalletHistoryLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : state is WalletHistoryLoaded
                                      ? ListView.builder(
                                          itemCount:
                                              state.walletResponse.data.length,
                                          itemBuilder: (context, index) {
                                            final transaction = state
                                                .walletResponse.data[index];
                                            final isDeposit =
                                                transaction.type == 'add';
                                            return TransactionItem(
                                              amount: transaction.amount,
                                              isDeposit: isDeposit,
                                              description:
                                                  transaction.type.tr(context),
                                              date: transaction.createdAt,
                                            );
                                          },
                                        )
                                      : state is WalletHistoryError
                                          ? Center(child: Text(state.error))
                                          : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
