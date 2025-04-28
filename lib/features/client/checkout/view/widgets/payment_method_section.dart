import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/checkout/view/widgets/credit_bottom_sheet.dart';
import 'package:embone/features/client/checkout/view/widgets/shipping_address_section.dart';
import 'package:embone/features/client/wallet/view/add_funds_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PaymentMethodSection extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final int selectedPaymentMethod;
  final ValueChanged<int> onMethodSelected;
  final VoidCallback onChange;

  const PaymentMethodSection({
    super.key,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.onMethodSelected,
    required this.onChange,
  });

  void _showCreditCardBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => const CreditCardBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'checkout_choose_payment_method_title'.tr(context),
      content: Column(
        children: [
          ...paymentMethods.map(
            (method) => PaymentMethodItem(
              isSelected: selectedPaymentMethod == method['id'],
              title: method['title'],
              icon: method['icon'],
              details: method['details'],
              logo: method['logo'],
              onTap: () {
                onMethodSelected(method['id']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddFundsScreen()),
                );
              },
              onChange: () => _showCreditCardBottomSheet(context),
            ),
          ),
        ],
      ),
      showHeader: false,
    );
  }
}

class PaymentMethodItem extends StatelessWidget {
  final bool isSelected;
  final String? title;
  final String icon;
  final String details;
  final String? logo;
  final VoidCallback onTap;
  final VoidCallback onChange;

  const PaymentMethodItem({
    super.key,
    required this.isSelected,
    this.title,
    required this.icon,
    required this.details,
    this.logo,
    required this.onTap,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? const Color(0xFF1565C0) : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF1565C0),
                      ),
                    )
                  : null,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20.w),
                  if (logo != null)
                    SvgPicture.asset(logo!, width: 40.w, height: 24.h),
                  SizedBox(width: 20.w),
                  if (details.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Text(
                        details,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  SizedBox(width: 20.w),
                  if (title != null)
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isSelected)
              TextButton(
                onPressed: onChange,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: Colors.red,
                ),
                child: Text(
                  'checkout_change_action'.tr(context),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
