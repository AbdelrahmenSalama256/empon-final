import 'package:bloc/bloc.dart';
import 'package:embone/features/client/menu/data/model/wallet_history_model.dart';
import 'package:embone/features/client/menu/data/repo/wallet_repo.dart';
import 'package:embone/features/client/menu/view/cubit/wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  final WalletRepo walletRepo;
  WalletCubit(this.walletRepo) : super(WalletInitial());

  List<WalletTransactionModel> transactions = [];
  String balance = '0.00';
  init() {
    fetchWalletHistory();
    fetchWalletBalance();
  }

  Future<void> fetchWalletHistory() async {
    emit(WalletHistoryLoading());
    final result = await walletRepo.fetchWalletHistory();
    result.fold(
      (error) => emit(WalletHistoryError(error)),
      (walletResponse) {
        transactions = walletResponse.data;
        emit(WalletHistoryLoaded(walletResponse));
      },
    );
  }

  Future<void> fetchWalletBalance() async {
    emit(WalletLoading());
    final result = await walletRepo.fetchWalletBalance();
    result.fold(
      (error) => emit(WalletError(error)),
      (walletResponse) {
        balance = walletResponse.data.balance;
        emit(WalletLoaded(walletResponse));
      },
    );
  }
}
