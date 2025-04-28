import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/checkout/view/widgets/change_address_sheet.dart';
import 'package:embone/features/client/checkout/view/widgets/order_summary_section.dart';
import 'package:embone/features/client/checkout/view/widgets/payment_method_section.dart';
import 'package:embone/features/client/checkout/view/widgets/shipping_address_section.dart';
import 'package:embone/features/client/order/view/success_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedPaymentMethod = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'title': 'Cash on Delivery',
      'icon': "assets/images/svg/cash-on-delivery.svg",
      'color': Colors.green,
      'logo': "assets/images/svg/cash-on-delivery.svg",
      'details': '',
    },
    {
      'id': 1,
      'icon': "assets/images/svg/mastercard.svg",
      'color': Colors.orange,
      'details': '****3947',
      'logo': 'assets/images/svg/mastercard.svg',
    },
  ];
  void _showChangeAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => const ChangeAddressSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppHeader(
                      title: 'checkout_payment_title'.tr(context),
                      showBackButton: true,
                      centerTitle: true,
                    ),
                    ShippingAddressSection(onChange: () {
                      _showChangeAddressBottomSheet(context);
                    }),
                    SizedBox(height: 16.h),
                    PaymentMethodSection(
                      paymentMethods: _paymentMethods,
                      selectedPaymentMethod: _selectedPaymentMethod,
                      onMethodSelected: (id) {
                        setState(() {
                          _selectedPaymentMethod = id;
                        });
                      },
                      onChange: () {},
                    ),
                    SizedBox(height: 16.h),
                    const OrderSummarySection(),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              child: AppButton(
                onPressed: () {
                  navigateReplac(context, const SuccessOrderScreen());
                },
                text: 'checkout_submit_order_button'.tr(context),
                textStyle: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
