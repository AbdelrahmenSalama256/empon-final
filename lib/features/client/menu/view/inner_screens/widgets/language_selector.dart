import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<GlobalCubit>().changeLanguage();

            showToast(context,
                message: context.read<GlobalCubit>().language == "en"
                    ? "تم تغيير اللغة إلى العربية"
                    : "Language changed to English",
                state: ToastStates.success);
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/images/svg/globe.svg",
                      width: 24.w,
                      height: 24.h,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "language".tr(context),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      context.read<GlobalCubit>().language == "ar"
                          ? "English"
                          : "العربية",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                        fontFamily: context.read<GlobalCubit>().language == "en"
                            ? "Beiruti"
                            : "Poppins",
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chevron_right,
                      size: 24.sp,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
