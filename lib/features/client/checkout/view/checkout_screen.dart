import 'package:embone/core/component/custom_loading_indicator.dart';
import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/cart/data/repo/cart_repo.dart';
import 'package:embone/features/client/cart/view/cubit/cart_cubit.dart';
import 'package:embone/features/client/checkout/data/repo/checkout_repo.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';
import 'package:embone/features/client/checkout/view/widgets/change_address_sheet.dart';
import 'package:embone/features/client/checkout/view/widgets/order_summary_section.dart';
import 'package:embone/features/client/checkout/view/widgets/payment_method_section.dart';
import 'package:embone/features/client/checkout/view/widgets/shipping_address_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'widgets/add_address_sheet.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CheckoutCubit(sl<CheckoutRepo>())),
        BlocProvider(create: (context) => RegisterCubit(sl<RegisterRepo>())),
        BlocProvider(
            create: (context) => CartCubit(sl<CartRepo>())..fetchCart()),
        BlocProvider(create: (context) => GlobalCubit()..fetchUserAddresses()),
      ],
      child: BlocListener<GlobalCubit, GlobalState>(
        listener: (context, state) {
          if (state is GetAddressSuccess) {
            if (state.addresses.isNotEmpty) {
              if (_selectedAddress == null) {
                setState(() {
                  _selectedAddress = state.addresses.first;
                });
              }
              _showChangeAddressBottomSheet(context);
            } else {
              _showAddAddressBottomSheet(context);
            }
          } else if (state is GetAddressError) {
            showToast(context,
                message: 'error_fetching_addresses'.tr(context),
                state: ToastStates.error);
            // Show AddAddressSheet on error
            _showAddAddressBottomSheet(context);
          }
        },
        child: BlocBuilder<GlobalCubit, GlobalState>(
          builder: (context, globalState) {
            return BlocBuilder<CheckoutCubit, CheckoutState>(
              builder: (context, checkoutState) {
                final isLoading = globalState is GetAddressLoading ||
                    checkoutState is CheckoutLoading;
                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: Colors.white,
                      body: SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AppHeader(
                                      title:
                                          'checkout_payment_title'.tr(context),
                                      showBackButton: true,
                                      centerTitle: true,
                                    ),
                                    ShippingAddressSection(
                                      address: _selectedAddress,
                                      onChange: () {
                                        _showChangeAddressBottomSheet(context);
                                      },
                                    ),
                                    SizedBox(height: 16.h),
                                    const PaymentMethodSection(),
                                    SizedBox(height: 16.h),
                                    OrderSummarySection(
                                      cartCubit: context.read<CartCubit>(),
                                      checkoutCubit:
                                          context.read<CheckoutCubit>(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                    if (isLoading)
                      const Center(
                        child: CustomLoadingIndicator(),
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

  void _showChangeAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GlobalCubit>()),
          BlocProvider.value(value: context.read<RegisterCubit>()),
          BlocProvider.value(value: context.read<CheckoutCubit>()),
          BlocProvider.value(value: context.read<CartCubit>()),
        ],
        child: ChangeAddressSheet(
          globalCubit: context.read<GlobalCubit>(),
          registerCubit: context.read<RegisterCubit>(),
          selectedAddress: _selectedAddress,
          onAddressSelected: (address) async {
            setState(() => _selectedAddress = address);
            await context
                .read<CheckoutCubit>()
                .createOrderInfo(address.id ?? 0);
            Navigator.pop(modalContext);
          },
          onAddAddress: () {
            Navigator.pop(modalContext);
            _showAddAddressBottomSheet(context);
          },
        ),
      ),
    );
  }

  void _showAddAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (modalContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GlobalCubit>()),
          BlocProvider.value(value: context.read<RegisterCubit>()),
        ],
        child: AddAddressSheet(
          globalCubit: context.read<GlobalCubit>(),
          registerCubit: context.read<RegisterCubit>(),
          onAddressAdded: (newAddress) {
            Navigator.pop(modalContext);
            context.read<GlobalCubit>().fetchUserAddresses();
          },
        ),
      ),
    );
  }
}
