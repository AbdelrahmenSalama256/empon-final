import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showPaymentMethodDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) =>const  PaymentMethodPopup(),
  );
}

class PaymentMethodPopup extends StatefulWidget {
  const PaymentMethodPopup({super.key});

  @override
  State<PaymentMethodPopup> createState() => _PaymentMethodPopupState();
}

class _PaymentMethodPopupState extends State<PaymentMethodPopup> {
  int? _selectedMethod;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'paymob',
      'logo': 'assets/images/paymob.png',
    },
    {
      'name': 'vodafone',
      'logo': 'assets/images/vodafone.png',
    },
    {
      'name': 'orange',
      'logo': 'assets/images/orange.png',
    },
    {
      'name': 'wepay',
      'logo': 'assets/images/wepay.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'choose_payment_method'.tr(context),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              textDirection: TextDirection.rtl,
            ),
             Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20.h),
            ...List.generate(_paymentMethods.length, (index) {
              final method = _paymentMethods[index];
              return InkWell(
                onTap: () => setState(() => _selectedMethod = index),
                child: Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.w),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _selectedMethod,
                        onChanged: (value) =>
                            setState(() => _selectedMethod = value),
                      ),
                       SizedBox(width: 12.w),
                      ClipRRect(
                        
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          method['logo'],
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                       SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          (method['name'] as String).tr(context),
                          style:  TextStyle(fontSize: 16.sp),
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
