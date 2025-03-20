import 'package:embone/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CurrentLocationButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrentLocationButtonWidget({Key? key, required this.onPressed})
      : super(key: key);

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
