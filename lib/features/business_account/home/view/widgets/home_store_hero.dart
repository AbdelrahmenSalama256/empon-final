import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeStoreHero extends StatelessWidget {
  const HomeStoreHero({super.key});

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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.r),
              bottomRight: Radius.circular(16.r),
            ),
            child: Image.asset(
              'assets/images/profile_store.png',
              fit: BoxFit.fill,
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
              ),
              child: Center(
                child: Image.asset('assets/images/brand-logo.png'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
