import 'package:bloc/bloc.dart';
import 'package:embone/core/common/logs.dart';
import 'package:embone/features/client/menu/data/repo/account_repo.dart';
import 'package:embone/features/client/menu/view/cubit/accounts_state.dart';

import '../../data/model/account_model.dart';

class AccountsCubit extends Cubit<AccountsState> {
  final AccountsRepo accountRepo;
  AccountResponseModel? account;
  AccountsCubit(this.accountRepo) : super(AccountsInitial());
  void init(int accountId) {
    fetchAccountDetails(accountId);
  }

  Future<void> fetchAccountDetails(int accountId) async {
    emit(AccountLoading());
    final result = await accountRepo.fetchAccountDetails(accountId);
    result.fold(
      (error) => emit(AccountError(error)),
      (accountResponse) {
        account = accountResponse;
        Print.info(
            'Account details fetched successfully: ${accountResponse.data}');
        emit(AccountLoaded(accountResponse.data));
      },
    );
  }
}
