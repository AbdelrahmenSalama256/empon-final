import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/wallet/view/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'wallet_details'.tr(context),
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'all_transactions'.tr(context),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                        ),
                      ),
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
          ],
        ),
      ),
    );
  }
}
