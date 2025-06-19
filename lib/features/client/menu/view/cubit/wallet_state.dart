import 'package:embone/features/client/menu/data/model/wallet_balance_model.dart';
import 'package:embone/features/client/menu/data/model/wallet_history_model.dart';

class WalletState {}

final class WalletInitial extends WalletState {}

class WalletHistoryLoading extends WalletState {}

class WalletHistoryLoaded extends WalletState {
  final WalletHistoryResponseModel walletResponse;

  WalletHistoryLoaded(this.walletResponse);
}

class WalletHistoryError extends WalletState {
  final String error;

  WalletHistoryError(this.error);
}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletBalanceResponseModel walletResponse;

  WalletLoaded(this.walletResponse);
}

class WalletError extends WalletState {
  final String error;

  WalletError(this.error);
}
