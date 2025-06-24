import 'package:bloc/bloc.dart';
import 'package:embone/features/business_account/home/data/models/business_account_model.dart';
import 'package:embone/features/business_account/home/data/repo/account_repo.dart';

part 'account_state.dart';

class BusinessAccountCubit extends Cubit<BusinessAccountState> {
  final BusinessAccountRepo repo;
  BusinessAccount? accountData;
  BusinessAccountCubit(this.repo) : super(BusinessAccountInitial());

  Future<void> fetchBusinessAccount(int accountId) async {
    emit(BusinessAccountLoading());

    final result = await repo.fetchBusinessAccountById(accountId);

    result.fold(
      (error) => emit(BusinessAccountError(error)),
      (response) {
        accountData = response.data;
        emit(BusinessAccountLoaded(accountData!));
      },
    );
  }
}
