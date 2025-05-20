import 'package:embone/core/component/custom_toast.dart';
import 'package:embone/core/component/widgets/app_button.dart';
import 'package:embone/core/component/widgets/app_header.dart';
import 'package:embone/core/constants/navigation.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/cubit/global_state.dart';
import 'package:embone/core/locale/app_loacl.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/auth/data/repo/register_repo.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_cubit.dart';
import 'package:embone/features/client/auth/view/pages/cubit/register_state.dart';
import 'package:embone/features/client/checkout/data/repo/checkout_repo.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_cubit.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';
import 'package:embone/features/client/checkout/view/widgets/change_address_sheet.dart';
import 'package:embone/features/client/checkout/view/widgets/order_summary_section.dart';
import 'package:embone/features/client/checkout/view/widgets/payment_method_section.dart';
import 'package:embone/features/client/checkout/view/widgets/shipping_address_section.dart';
import 'package:embone/features/client/order/view/success_order_screen.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
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
  int _selectedPaymentMethod = 0;
  Address? _selectedAddress;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 0,
      'title': 'Cash on Delivery',
      'icon': "assets/images/svg/cash-on-delivery.svg",
      'color': Colors.green,
      'logo': "assets/images/svg/cash-on-delivery.svg",
      'details': '',
    },
    {
      'id': 1,
      'title': 'Mastercard',
      'icon': "assets/images/svg/mastercard.svg",
      'color': Colors.orange,
      'logo': "assets/images/svg/mastercard.svg",
      'details': '****3947',
    },
  ];

  void _showChangeAddressBottomSheet(BuildContext context) {
    final globalCubit = context.read<GlobalCubit>();
    final registerCubit = context.read<RegisterCubit>();

    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => ChangeAddressSheet(
        globalCubit: globalCubit,
        registerCubit: registerCubit,
        selectedAddress: _selectedAddress,
        onAddressSelected: (address) {
          setState(() => _selectedAddress = address);
          Navigator.pop(context);
        },
        onAddAddress: () {
          Navigator.pop(context);

          _showAddAddressBottomSheet(context, globalCubit, registerCubit);
        },
      ),
    );
  }

  void _showAddAddressBottomSheet(BuildContext context, GlobalCubit globalCubit,
      RegisterCubit registerCubit) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) => BlocProvider(
        create: (context) => registerCubit,
        child: BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return AddAddressSheet(
              globalCubit: globalCubit,
              registerCubit: registerCubit,
              onAddressAdded: (newAddress) {},
            );
          },
        ),
      ),
    ).whenComplete(() {
      globalCubit.fetchUserAddresses();
    }).then((value) {
      if (value == true) {
        _showChangeAddressBottomSheet(context);
        setState(() => _selectedAddress = value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(sl<CheckoutRepo>())..getCartInfo(),
      child: BlocBuilder<CheckoutCubit, CheckoutState>(
        builder: (context, state) {
          final checkoutCubit = context.read<CheckoutCubit>();
          return BlocProvider(
            create: (context) => RegisterCubit(sl<RegisterRepo>()),
            child: BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return BlocProvider(
                  create: (context) => GlobalCubit()..fetchUserAddresses(),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: BlocListener<GlobalCubit, GlobalState>(
                        listener: (context, state) {
                          if (state is GetAddressSuccess &&
                              _selectedAddress == null) {
                            setState(() {
                              _selectedAddress = context
                                  .read<GlobalCubit>()
                                  .userAddresses
                                  ?.firstOrNull;
                            });
                          } else if (state is GetAddressError) {
                            showToast(context,
                                message: 'error_fetching_addresses'.tr(context),
                                state: ToastStates.error);
                          }
                        },
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
                                    PaymentMethodSection(
                                      paymentMethods: _paymentMethods,
                                      selectedPaymentMethod:
                                          _selectedPaymentMethod,
                                      onMethodSelected: (id) {
                                        setState(() {
                                          _selectedPaymentMethod = id;
                                        });
                                      },
                                      onChange: () {},
                                    ),
                                    SizedBox(height: 16.h),
                                    OrderSummarySection(
                                      checkoutCubit: checkoutCubit,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16.w),
                              child: AppButton(
                                onPressed: () {
                                  if (_selectedAddress == null) {
                                    showToast(context,
                                        message:
                                            'please_select_shipping_address'
                                                .tr(context),
                                        state: ToastStates.error);
                                    return;
                                  }
                                  navigateReplac(
                                      context, const SuccessOrderScreen());
                                },
                                text:
                                    'checkout_submit_order_button'.tr(context),
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
