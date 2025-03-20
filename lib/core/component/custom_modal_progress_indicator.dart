import 'package:flutter/material.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'custom_loading_indicator.dart';

class CustomModalProgressIndicator extends StatelessWidget {
  const CustomModalProgressIndicator({
    super.key,
    required this.inAsyncCall,
    required this.child,
  });

  final bool inAsyncCall;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      progressIndicator: const CustomLoadingIndicator(),
      color: AppColors.black,
      child: child,
    );
  }
}
