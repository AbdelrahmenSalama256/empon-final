import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_checkbox.dart'; // Import AppCheckbox
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/utils/validator.dart';
import 'package:embone/features/client/auth/view/widgets/auth_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreditCardBottomSheet extends StatefulWidget {
  const CreditCardBottomSheet({super.key});

  @override
  State<CreditCardBottomSheet> createState() => _CreditCardBottomSheetState();
}

class _CreditCardBottomSheetState extends State<CreditCardBottomSheet> {
  bool _saveCard = false;
  final TextEditingController _cardholderNameController =
      TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardholderNameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cardholder Name Field
          Text(
            'credit_card_name_label'.tr(context),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _cardholderNameController,
            hintText: 'credit_card_name_hint'.tr(context),
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (p0) {
              Validators.validateRequired(
                p0,
                'credit_card_name_label'.tr(context),
                context,
              );
              return null;
            },
          ),
          SizedBox(height: 16.h),

          // Card Number Field
          Text(
            'credit_card_number_label'.tr(context),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 8.h),
          AppTextField(
            controller: _cardNumberController,
            hintText: '5546 8205 3603 3947',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: (p0) {
              Validators.validateRequired(
                p0,
                'credit_card_number_label'.tr(context),
                context,
              );
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16), // Limit to 16 digits
            ],
          ),
          SizedBox(height: 16.h),

          // Expiry Date and CVV Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'credit_card_expiry_label'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppTextField(
                      controller: _expiryDateController,
                      hintText: 'MM/YY',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (p0) {
                        Validators.validateRequired(
                          p0,
                          'credit_card_expiry_label'.tr(context),
                          context,
                        );
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4), // MM/YY format
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'credit_card_cvv_label'.tr(context),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    AppTextField(
                      controller: _cvvController,
                      hintText: '358',
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      validator: (p0) {
                        Validators.validateRequired(
                          p0,
                          'credit_card_cvv_label'.tr(context),
                          context,
                        );
                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3), // CVV is 3 digits
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Save Card Checkbox
          AppCheckbox(
            value: _saveCard,
            onChanged: (value) {
              setState(() {
                _saveCard = value ?? false;
              });
            },
            text: 'credit_card_save_label'.tr(context),
          ),
          SizedBox(height: 16.h),

          // Save Button
          AppButton(
            onPressed: () {
              // Handle save action (e.g., update payment method)
              Navigator.pop(context);
            },
            text: 'credit_card_save_button'.tr(context),
            textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
