import 'package:bloc/bloc.dart';
import 'package:embone/features/client/checkout/data/repo/checkout_repo.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';

import '../../data/model/order_response_model.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepo checkoutRepo;

  CheckoutCubit(this.checkoutRepo) : super(CheckoutInitial());
  OrderResponseModel? orderResponse;
  Future<void> createOrderInfo(int addressId) async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.createOrderInfo(addressId);
    result.fold(
      (error) => emit(CheckoutError(error)),
      (response) {
        orderResponse = response;
        emit(CheckoutLoaded(response));
      },
    );
  }

  Future<void> generatePaymentUrl(double amount) async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.generatePaymentUrl(amount);
    result.fold(
      (error) => emit(CheckoutError(error)),
      (response) => emit(PaymentUrlGenerated(response)),
    );
  }
}
