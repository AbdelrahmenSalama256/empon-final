import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widget/keypad_button.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  String _amount = '';

  void _addDigit(String digit) {
    setState(() {
      if (_amount.length < 10) {
        _amount += digit;
      }
    });
  }

  void _clearAmount() {
    setState(() {
      _amount = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
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
                    SizedBox(height: 0.h),
                    Text(
                      'amount_to_pay'.tr(context),
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '11,542 ${'egp'.tr(context)}',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      height: 61.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _amount.isEmpty
                              ? Text(
                                  'enter_amount_here'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                )
                              : Text(
                                  _amount.isEmpty ? '0' : _amount,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 2.0,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        children: [
                          KeypadButton(digit: '1', onTap: _addDigit),
                          KeypadButton(digit: '2', onTap: _addDigit),
                          KeypadButton(digit: '3', onTap: _addDigit),
                          KeypadButton(digit: '4', onTap: _addDigit),
                          KeypadButton(digit: '5', onTap: _addDigit),
                          KeypadButton(digit: '6', onTap: _addDigit),
                          KeypadButton(digit: '7', onTap: _addDigit),
                          KeypadButton(digit: '8', onTap: _addDigit),
                          KeypadButton(digit: '9', onTap: _addDigit),
                          KeypadButton(digit: '00', onTap: _addDigit),
                          KeypadButton(digit: '0', onTap: _addDigit),
                          IconButton(
                            onPressed: _clearAmount,
                            icon: Icon(
                              Icons.backspace_outlined,
                              size: 24.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.w),
                      width: 171.w,
                      height: 62.h,
                      child: AppButton(
                        onPressed: () {},
                        text: 'transfer'.tr(context),
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
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
