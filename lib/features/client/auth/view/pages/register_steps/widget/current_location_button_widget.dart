import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CurrentLocationButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrentLocationButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "currentLocationBtn",
      backgroundColor: Colors.white,
      mini: true,
      onPressed: onPressed,
      child: const Icon(Icons.my_location, color: AppColors.primary),
    );
  }
}
