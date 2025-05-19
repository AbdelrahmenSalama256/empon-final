import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/constants/app_colors.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/contacts/view/widgets/contact_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  @override
  Widget build(BuildContext context) {
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

        void addContacts() {
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
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                // Logo
                Padding(
                  padding: EdgeInsets.only(top: 24.h),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 120.w,
                      height: 40.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Title and Subtitle
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'add_contacts_title'.tr(context),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'add_contacts_subtitle'.tr(context),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contacts List
                Expanded(
                  child: cubit.isFetchingContacts
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.primary),
                        )
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

                // Bottom Buttons
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed:
                            cubit.isFetchingContacts ? null : addContacts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: cubit.isFetchingContacts
                            ? SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text('next'.tr(context)),
                      ),
                      SizedBox(height: 16.h),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          minimumSize: Size(double.infinity, 50.h),
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text('back'.tr(context)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
