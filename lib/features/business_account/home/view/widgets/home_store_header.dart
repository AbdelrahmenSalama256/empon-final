import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeStoreHeader extends StatelessWidget {
  final VoidCallback onBackPressed;
  final bool isVendor;
  final String? name;

  const HomeStoreHeader({
    super.key,
    required this.onBackPressed,
    this.isVendor = false,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AppHeader(
      title: isVendor != true ? name : '',
      centerTitle: context.read<GlobalCubit>().language == "ar" ? false : true,
      showBackButton: isVendor != true ? true : false,
      style: HeaderStyle.standard,
      onBackPressed: onBackPressed,
    );
  }
}
