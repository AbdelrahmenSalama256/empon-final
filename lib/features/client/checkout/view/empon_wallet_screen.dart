import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:embone/features/client/checkout/data/repo/checkout_repo.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';
import 'package:embone/features/client/checkout/view/widgets/custom_dialog.dart';
import 'package:embone/features/client/menu/data/repo/wallet_repo.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_cubit.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/app_colors.dart';
import 'payment_screen_webview.dart';

class EmponWalletScreen extends StatefulWidget {
  final double grandTotal;

  const EmponWalletScreen({super.key, required this.grandTotal});

  @override
  State<EmponWalletScreen> createState() => _EmponWalletScreenState();
}

class _EmponWalletScreenState extends State<EmponWalletScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _refreshBalance() {
    final cubit = context.read<WalletCubit>();
    cubit.fetchWalletBalance();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletCubit(sl<WalletRepo>())..fetchWalletBalance(),
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
              message: 'unexpected_error'.tr(context),
              state: ToastStates.error,
            );
          }
        },
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, walletState) {
            final walletCubit = context.read<WalletCubit>();
            final bool isButtonDisabled =
                double.parse(walletCubit.balance) < widget.grandTotal;

            return Scaffold(
              backgroundColor: Colors.white,
              body: BlocProvider(
                create: (context) => CheckoutCubit(sl<CheckoutRepo>()),
                child: BlocBuilder<CheckoutCubit, CheckoutState>(
                  builder: (context, state) {
                    final checkoutCubit = context.read<CheckoutCubit>();
                    return BlocListener<CheckoutCubit, CheckoutState>(
                      listener: (context, state) {
                        if (state is PaymentUrlGenerated) {
                          // Navigate to WebView when payment URL is generated
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => PaymentWebViewScreen(
                                paymentUrl: state.paymentUrlResponse.data,
                                response: state.paymentUrlResponse,
                              ),
                            ),
                          );
                        } else if (state is CheckoutError) {
                          showToast(
                            context,
                            message: 'insufficient_balance'.tr(context),
                            state: ToastStates.error,
                          );
                        }
                      },
                      child: SafeArea(
                        child: Column(
                          children: [
                            AppHeader(
                              title: 'empon_wallet'.tr(context),
                              showBackButton: true,
                              centerTitle: true,
                            ),
                            walletState is WalletLoading
                                ? const Expanded(
                                    child: Center(
                                      child: CustomLoadingIndicator(),
                                    ),
                                  )
                                : Expanded(
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.all(16.w),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const EmponWalletScreen(
                                                          grandTotal: 0.0),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.w,
                                                  vertical: 16.h),
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(12.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 70.w,
                                                    height: 50.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.r),
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        'assets/images/svg/cash-on-delivery.svg',
                                                        width: 40.w,
                                                        height: 40.h,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12.w),
                                                  Text(
                                                    'empon_wallet'.tr(context),
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                flex: 2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "current_balance"
                                                          .tr(context),
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    // wallet balance text value
                                                    SizedBox(width: 5.w),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        '${walletCubit.balance} ${'egp'.tr(context)}',
                                                        style: TextStyle(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              AppColors.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: AppButton(
                                                  onPressed: //(){
                                                      () =>
                                                          showPaymentMethodDialog(
                                                              context),
                                                  //    CustomPopup.show(
                                                  //   context: context,
                                                  //   type: PopupType.custom,
                                                  //   title:"chose payment method",
                                                  //   customContent:
                                                  //  ),
                                                  // } ,//_refreshBalance,
                                                  text: 'recharge'.tr(context),
                                                  backgroundColor:
                                                      const Color(0xff64B95C),
                                                  prefixIcon: SvgPicture.asset(
                                                    "assets/images/svg/lucide_folder-input.svg",
                                                    width: 20.w,
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 8.h),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 40.h),
                                          Row(
                                            children: [
                                              Text(
                                                "copon".tr(context),
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              // wallet balance text value
                                              SizedBox(width: 5.w),
                                              Expanded(
                                                flex: 3,
                                                child: AppTextField(
                                                  controller: _amountController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  hintText:
                                                      'enter_copon'.tr(context),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 12.w,
                                                          vertical: 10.h),
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Expanded(
                                                flex: 1,
                                                child: AppButton(
                                                  onPressed: _refreshBalance,
                                                  text: 'apply'.tr(context),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 8.h),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20.h),
                                        ],
                                      ),
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.all(16.w),
                              child: AppButton(
                                onPressed: isButtonDisabled
                                    ? null
                                    : () {
                                        if (widget.grandTotal >
                                            double.parse(walletCubit.balance)) {
                                          showToast(
                                            context,
                                            message: 'insufficient_balance'
                                                .tr(context),
                                            state: ToastStates.error,
                                          );
                                        } else {
                                          checkoutCubit.generatePaymentUrl(
                                            widget.grandTotal,
                                          );
                                        }
                                      },
                                text: 'pay'.tr(context) +
                                    widget.grandTotal.toStringAsFixed(2),
                                isLoading: state is CheckoutLoading,
                                borderRadius: BorderRadius.circular(8.r),
                                backgroundColor: isButtonDisabled
                                    ? Colors.grey
                                    : const Color(0xff64B95C),
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
          },
        ),
      ),
    );
  }
}
