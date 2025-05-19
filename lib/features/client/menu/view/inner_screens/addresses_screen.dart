import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/register_steps/add_new_address_page.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/address_card.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/edit_address_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../auth/data/models/user_data_model.dart';

class AddressesScreen extends StatefulWidget {
  final bool isSelectionMode;
  final Function(Address)? onAddressSelected;

  const AddressesScreen({
    super.key,
    this.isSelectionMode = false,
    this.onAddressSelected,
  });

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GlobalCubit>().fetchUserAddresses();
  }

  void _editAddress(Address address, BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => RegisterCubit(sl<RegisterRepo>()),
        child: EditAddressDialog(
          address: address,
          onSave: (updatedAddress) {
            context
                .read<GlobalCubit>()
                .updateAddress(address.id ?? 0, updatedAddress);
          },
          onDelete: () {
            context.read<GlobalCubit>().deleteAddress(address.id ?? 0);
            Navigator.pop(dialogContext);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFDFDFD),
      body: SafeArea(
        child: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, state) {
            return BlocConsumer<GlobalCubit, GlobalState>(
              listener: (context, state) {
                if (state is GetAddressError) {
                  showToast(context,
                      message: state.message, state: ToastStates.error);
                } else if (state is ProfileError) {
                  showToast(context,
                      message: state.message, state: ToastStates.error);
                } else if (state is ProfileUpdated) {
                  showToast(context,
                      message: 'address_updated_successfully'.tr(context),
                      state: ToastStates.success);
                  context.read<GlobalCubit>().fetchUserAddresses();
                }
              },
              builder: (context, state) {
                var addresses = context.read<GlobalCubit>().userAddresses;
                return Column(
                  children: [
                    AppHeader(
                      title: 'addresses'.tr(context),
                      centerTitle: true,
                      showBackButton: true,
                      backgroundColor: Colors.white,
                      onBackPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: state is GetAddressLoading
                          ? const Center(child: CircularProgressIndicator())
                          : addresses!.isEmpty
                              ? Center(
                                  child: Text('no_addresses'.tr(context),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.grey[600])))
                              : SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 16.h),
                                  child: Column(
                                    children: [
                                      ...addresses.map((address) => AddressCard(
                                            address: address,
                                            onEdit: () =>
                                                _editAddress(address, context),
                                            onDelete: () {
                                              context
                                                  .read<GlobalCubit>()
                                                  .deleteAddress(
                                                      address.id ?? 0);
                                            },
                                            onSelect: widget.isSelectionMode
                                                ? () {
                                                    if (widget
                                                            .onAddressSelected !=
                                                        null) {
                                                      widget.onAddressSelected!(
                                                          address);
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                : null,
                                            isSelectable:
                                                widget.isSelectionMode,
                                          )),
                                    ],
                                  ),
                                ),
                    ),
                    InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          BlocProvider(
                            create: (context) =>
                                RegisterCubit(sl<RegisterRepo>()),
                            child: AddNewAddressPage(
                              type: "profile",
                              onNextStep: () => Navigator.pop(context),
                              onPreviousStep: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        margin: EdgeInsets.only(top: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle_outline,
                                color: Colors.grey[600], size: 20.sp),
                            SizedBox(width: 8.w),
                            Text('add_location'.tr(context),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
