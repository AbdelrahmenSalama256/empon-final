import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreHero extends StatelessWidget {
  final String? storeLogo;
  final String? storeCover;
  const HomeStoreHero(
      {super.key, required this.storeLogo, required this.storeCover});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 146.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
            child: storeCover != null
                ? Image.network(
                    storeCover!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placholder.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/placholder.jpg',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Positioned(
          bottom: -31.h,
          right: 0.w,
          left: 0.w,
          child: GestureDetector(
            onTap: () {
              // showAccountsBottomSheet(context);
            },
            child: Container(
              width: 79.w,
              height: 79.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: storeLogo!.startsWith('http')
                      ? NetworkImage(storeLogo!)
                      : const AssetImage('assets/images/brand-logo.png')
                          as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
