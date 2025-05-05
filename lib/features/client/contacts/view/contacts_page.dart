import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/widget/queistions.dart';
import 'package:embone/features/client/contacts/view/invite_contacts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsPage extends StatelessWidget {
  final VoidCallback onNextStep;
  final VoidCallback onPreviousStep;
  const ContactsPage(
      {super.key, required this.onNextStep, required this.onPreviousStep});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              showBackButton: false,
              showLogo: true,
              onBackPressed: () => onPreviousStep(),
              title: 'register'.tr(context),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 32.h),
                    Image.asset(
                      'assets/images/get_contacts.png',
                      width: 360.w,
                      height: 240.h,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 24.h),
                    QuestionWidget(
                      question: 'enable_contact_upload'.tr(context),
                      subtitle: 'discover_people'.tr(context),
                    ),
                    SizedBox(height: 32.h),
                    AppButton(
                      text: 'next'.tr(context),
                      isLoading: false,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: cubit,
                              child: const InviteContactsPage(),
                            ),
                          ),
                        );
                      },
                      height: 50.h,
                      width: double.infinity,
                    ),
                    SizedBox(height: 16.h),
                    AppButton(
                      text: 'skip'.tr(context),
                      onPressed: () => onNextStep(),
                      height: 50.h,
                      type: AppButtonType.text,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
