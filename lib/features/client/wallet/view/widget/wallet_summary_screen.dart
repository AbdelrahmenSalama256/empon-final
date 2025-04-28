import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/wallet/view/wallet_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'transaction_item.dart';
import 'balance_card.dart';

class WalletSummaryScreen extends StatelessWidget {
  const WalletSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              AppHeader(
                title: 'wallet'.tr(context),
                showBackButton: true,
                centerTitle: true,
                style: HeaderStyle.standard,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'wallet'.tr(context),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.arrow_forward, size: 20.sp),
                ],
              ),
              SizedBox(height: 16.h),
              BalanceCard(
                balance: '11,542',
                currency: 'egp'.tr(context),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      navigateTo(context, const WalletDetailsScreen());
                    },
                    child: Text(
                      'view_now'.tr(context),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
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
                child: ListView(
                  children: [
                    TransactionItem(
                      amount: '1000',
                      isDeposit: true,
                      description: 'deposit'.tr(context),
                      date: '15 يوليو 2023, 6:30PM',
                    ),
                    TransactionItem(
                      amount: '500',
                      isDeposit: false,
                      description: 'payment_dev_ratio'.tr(context),
                      date: '15 يوليو 2023, 6:30PM',
                    ),
                    TransactionItem(
                      amount: '1000',
                      isDeposit: true,
                      description: 'refund_dev_ratio'.tr(context),
                      date: '15 يوليو 2023, 6:30PM',
                    ),
                    TransactionItem(
                      amount: '500',
                      isDeposit: false,
                      description: 'payment_nasbi_stores'.tr(context),
                      date: '15 يوليو 2023, 6:30PM',
                    ),
                    TransactionItem(
                      amount: '1000',
                      isDeposit: true,
                      description: 'refund_nasbi'.tr(context),
                      date: '15 يوليو 2023, 6:30PM',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
