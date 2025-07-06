import '../../data/model/account_model.dart';

class AccountsState {}

final class AccountsInitial extends AccountsState {}

final class AccountLoading extends AccountsState {}

final class AccountLoaded extends AccountsState {
  final Account account;
  AccountLoaded(this.account);
}

final class AccountError extends AccountsState {
  final String error;
  AccountError(this.error);
}

final class AccountStatusLoaded extends AccountsState {}
