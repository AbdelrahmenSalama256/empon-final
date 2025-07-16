import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/menu/view/widgets/approval_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/custom_popup.dart';
import '../../../../business_account/auth_bussniss_acc/view/cubit/account_cubit.dart';

class MenuApprovalItems extends StatelessWidget {
  final dynamic accountData;
  final GlobalCubit cubit;

  const MenuApprovalItems({
    super.key,
    required this.accountData,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        accountData!.type == 'business'
            ? Visibility(
              visible: accountData.isStore == 0,
              child: ApprovalItem(
                  title: 'identity_store_request'.tr(context),
                  status: ApprovalStatus.approved,
                  icon: Image.asset(
                    "assets/images/cycle-circle.png",
                    width: 24.w,
                    height: 24.h,
                  ),
                  approveButtonText: accountData.isStore == 0
                      ? 'adopt'.tr(context)
                      : 'congrates'.tr(context),
                  approveButtonColor: accountData.isStore == 0 ? Colors.red
                      : Colors.green, // Fixed: Use localized string
                  onApprove: () {
                    if (accountData.isStore == 0) {
                      context
                          .read<AccountCubit>()
                          .sendStoreRequest(accountId: cubit.businessId!);
                    }
                    if (accountData.isStore != 1) {
                      CustomPopup.show(
                        context: context,
                        type: PopupType.success,
                        title: "request_sent_successfully".tr(context),
                        message: "request_under_review".tr(context),
                      );
                    }
                  },
                ),
            )
            : const SizedBox(),
        ApprovalItem(
          title: 'identity_verification_request'.tr(context),
          status: ApprovalStatus.approved,
          approveButtonText: accountData.verified!
              ? _getVerificationStatusText(
                  context, accountData.verificationRequest)
              : 'adopt'.tr(context),
          approveButtonColor: accountData.verificationRequest == "pending"
              ? Colors.red
              : Colors.green,
          icon: Image.asset(
            "assets/images/verify.png",
            width: 24.w,
            height: 24.h,
          ),
          onApprove: () {
            context
                .read<AccountCubit>()
                .sendVerficationRequest(accountId: cubit.businessId!);

            CustomPopup.show(
              context: context,
              type: PopupType.success,
              title: "request_sent_successfully".tr(context),
              message: "request_under_review".tr(context),
            );
          },
        ),
      ],
    );
  }

  String _getVerificationStatusText(BuildContext context, String? status) {
    switch (status) {
      case "pending":
        return 'pending'.tr(context);
      case "approved":
        return 'approved'.tr(context);
      case "rejected":
        return 'rejected'.tr(context);
      default:
        return status ?? 'pending'.tr(context);
    }
  }
}
