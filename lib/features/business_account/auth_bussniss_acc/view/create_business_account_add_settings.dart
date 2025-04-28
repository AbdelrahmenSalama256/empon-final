import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/profile/add_profile_buisniss_account.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/business_account_settings.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/widgets/contact_info_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateBusinessAccountSettings extends StatefulWidget {
  final bool? isFromSetting;
  const CreateBusinessAccountSettings({super.key, this.isFromSetting});

  @override
  State<CreateBusinessAccountSettings> createState() =>
      _CreateBusinessAccountSettingsState();
}

class _CreateBusinessAccountSettingsState
    extends State<CreateBusinessAccountSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: widget.isFromSetting == true
                  ? 'edit_business_profile'.tr(context)
                  : 'continue_business_account'.tr(context),
              centerTitle: true,
              showBackButton: true,
              onBackPressed: () => Navigator.pop(context),
              style: HeaderStyle.standard,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  const BusinessAccountSettings(),
                  const ContactInfoStep(),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: AppButton(
                      text: 'next'.tr(context),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const AddProfilePhotoForBuisnissAccountPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
