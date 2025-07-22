import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/business_account/auth_bussniss_acc/view/cubit/account_state.dart';
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
    return BlocListener<AccountCubit, AccountState>(
      listener: (context, state) {
        if (state is StoreRequestSuccess || state is StoreRequestSuccess) {
          CustomPopup.show(
            context: context,
            type: PopupType.success,
            title: "request_sent_successfully".tr(context),
            message: "request_under_review".tr(context),
          );
        } else if (state is StoreRequestError) {
          CustomPopup.show(
            context: context,
            type: PopupType.error,
            title: "error".tr(context),
            message: state.message,
          );
        }
      },
      child: BlocBuilder<AccountCubit, AccountState>(
        builder: (context, state) {
          return Wrap(
            children: [
              // ✅ Business Store Request
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
                            ? _getVerificationStatusText(
                                context, accountData.storeRequest)
                            : 'congrates'.tr(context),
                        approveButtonColor: accountData.isStore == 0
                            ? Colors.red
                            : Colors.green,
                        onApprove: () {
                          if (accountData.isStore == 0) {
                            if (accountData.storeRequest != "approved") {
                              context.read<AccountCubit>().sendStoreRequest(
                                  accountId: cubit.businessId!);
                            }
                          }
                        },
                        isLoading: state is StoreRequestLoading ? true : false,
                      ),
                    )
                  : const SizedBox(),

              // ✅ Identity Verification
              Visibility(
                visible: accountData.verificationRequest != "approved",
                child: ApprovalItem(
                  title: 'identity_verification_request'.tr(context),
                  status: ApprovalStatus.approved,
                  approveButtonText: accountData.verified!
                      ? _getVerificationStatusText(
                          context, accountData.verificationRequest)
                      : 'adopt'.tr(context),
                  approveButtonColor:
                      accountData.verificationRequest != "approved"
                          ? Colors.red
                          : Colors.green,
                  icon: Image.asset(
                    "assets/images/verify.png",
                    width: 24.w,
                    height: 24.h,
                  ),
                  onApprove: () {
                    if (accountData.verificationRequest != "approved") {
                      context
                          .read<AccountCubit>()
                          .sendVerficationRequest(accountId: cubit.businessId!);
                    }
                  },
                  isLoading: state is VerficationRequestLoading ? true : false,
                ),
              ),
            ],
          );
        },
      ),
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
