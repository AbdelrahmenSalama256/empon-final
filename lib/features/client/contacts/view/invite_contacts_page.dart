import 'package:embone/core/component/custom_header.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/network/local_network.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
// import 'package:embone/features/client/auth/view/pages/email/email_page.dart';
import 'package:embone/features/client/contacts/view/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/invitation_footer.dart';

class InviteContactsPage extends StatefulWidget {
  const InviteContactsPage({super.key});

  @override
  State<InviteContactsPage> createState() => _InviteContactsPageState();
}

class _InviteContactsPageState extends State<InviteContactsPage> {
  @override
  Widget build(BuildContext context) {
    final isRTL = sl<CacheHelper>().getCachedLanguage() == "ar";

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterError) {
          showToast(context, message: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        if (cubit.contacts.isEmpty && !cubit.isFetchingContacts) {
          cubit.fetchContacts(context);
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                CustomHeader(
                  showBackButton: false,
                  showLogo: true,
                  onBackPressed: () => Navigator.pop(context),
                  title: 'register'.tr(context),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Align(
                    alignment:
                        isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Text(
                      'invite_contacts_title'.tr(context),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: cubit.isFetchingContacts
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary))
                      : cubit.contacts.isEmpty
                          ? Center(child: Text('no_contacts_found'.tr(context)))
                          : ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              itemCount: cubit.contacts.length,
                              itemBuilder: (context, index) {
                                final contact = cubit.contacts[index];
                                return ContactListItem(
                                  contact: contact,
                                  onTap: () {
                                    cubit.toggleContactSelection(contact.id);
                                    setState(() {});
                                  },
                                );
                              },
                            ),
                ),
                InvitationFooter(
                  isLoading: false,
                  onSendPressed: () {
                    if (!cubit.hasSelectedContacts) {
                      showToast(context,
                          message: 'select_at_least_one_contact'.tr(context),
                          state: ToastStates.error);
                      return;
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider.value(
                    //       value: cubit,
                    //       child: const EmailPage(),
                    //     ),
                    //   ),
                    // );
                  },
                  onDonePressed: () {
                    if (!cubit.hasSelectedContacts) {
                      showToast(context,
                          message: 'select_at_least_one_contact'.tr(context),
                          state: ToastStates.error);
                      return;
                    }
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => BlocProvider.value(
                    //       value: cubit,
                    //       child: const EmailPage(),
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
