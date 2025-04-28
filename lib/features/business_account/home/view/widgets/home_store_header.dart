import 'package:flutter/material.dart';
import 'package:embone/core/component/widgets/app_header.dart';

class HomeStoreHeader extends StatelessWidget {
  final VoidCallback onBackPressed;

  const HomeStoreHeader({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: '',
      centerTitle: true,
      showBackButton: true,
      style: HeaderStyle.standard,
      onBackPressed: onBackPressed,
    );
  }
}
