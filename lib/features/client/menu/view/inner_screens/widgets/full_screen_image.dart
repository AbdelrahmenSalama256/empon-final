import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/constants/app_colors.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const FullScreenImage({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: heroTag,
            child: Image.network(
              imagePath,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: AppColors.primary,
                    strokeWidth: 2.w,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                final file = File(imagePath);
                if (file.existsSync()) {
                  return Image.file(
                    file,
                    fit: BoxFit.contain,
                  );
                }
                return Image.asset(
                  "assets/images/placholder.jpg",
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
