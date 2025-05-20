import 'package:bloc/bloc.dart';
import 'package:embone/features/client/checkout/data/model/cart_info_model.dart';
import 'package:embone/features/client/checkout/data/repo/checkout_repo.dart';
import 'package:embone/features/client/checkout/view/cubit/checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutRepo checkoutRepo;

  CheckoutCubit(this.checkoutRepo) : super(CheckoutInitial());

  CartInfoModel? cartInfoModel;

  Future<void> getCartInfo() async {
    emit(CheckoutLoading());
    final result = await checkoutRepo.getCartInfo();
    result.fold(
      (error) => emit(CheckoutError(error)),
      (cartInfo) {
        cartInfoModel = cartInfo;
        emit(CheckoutLoaded(cartInfo));
      },
    );
  }
}
