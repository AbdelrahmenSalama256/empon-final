import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/menu/view/inner_screens/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeAddressSheet extends StatelessWidget {
  final GlobalCubit globalCubit;
  final RegisterCubit registerCubit;
  final Address? selectedAddress;
  final Function(Address) onAddressSelected;
  final VoidCallback onAddAddress;

  const ChangeAddressSheet({
    super.key,
    required this.globalCubit,
    required this.registerCubit,
    this.selectedAddress,
    required this.onAddressSelected,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: globalCubit,
      child: BlocProvider.value(
        value: registerCubit,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 16.h),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'select_shipping_address'.tr(context),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                BlocBuilder<GlobalCubit, GlobalState>(
                  builder: (context, state) {
                    var addresses =
                        context.read<GlobalCubit>().userAddresses ?? [];
                    return state is GetAddressLoading
                        ? const Center(child: CircularProgressIndicator())
                        : addresses.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  'no_addresses'.tr(context),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  ...addresses.map((address) => InkWell(
                                        onTap: () {
                                          onAddressSelected(address);
                                        },
                                        child: AddressCard(
                                          address: address,
                                          onEdit: () {},
                                          onDelete: () {},
                                          onSelect: () {
                                            onAddressSelected(address);
                                          },
                                          isSelectable: true,
                                          isSelected:
                                              selectedAddress?.id == address.id,
                                        ),
                                      )),
                                ],
                              );
                  },
                ),
                SizedBox(height: 16.h),
                InkWell(
                  onTap: onAddAddress,
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
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle_outline,
                            color: Colors.grey[600], size: 20.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'add_location'.tr(context),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
