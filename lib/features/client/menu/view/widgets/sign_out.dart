import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  const SignOutButton({super.key, required this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xffEC4B4B),
        text: text ?? "sign_out".tr(context),
        textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
      ),
    );
  }
}
