import 'package:bloc/bloc.dart';
import 'package:embone/features/client/menu/data/model/privacy_policy_model.dart';
import 'package:embone/features/client/menu/data/repo/privacy_policy_repo.dart';
import 'package:embone/features/client/menu/view/cubit/privacy_policy_state.dart';

class PrivacyPolicyCubit extends Cubit<PrivacyPolicyState> {
  final PrivacyPolicyRepo privacyPolicyRepo;
  PrivacyPolicy? privacyPolicy;

  PrivacyPolicyCubit(this.privacyPolicyRepo) : super(PrivacyPolicyInitial());

  void init() {
    fetchPrivacyPolicy();
  }

  Future<void> fetchPrivacyPolicy() async {
    if (isClosed) return;
    emit(PrivacyPolicyLoading());
    final result = await privacyPolicyRepo.fetchPrivacyPolicy();
    if (isClosed) return;
    result.fold(
      (error) {
        emit(PrivacyPolicyError(error));
      },
      (policyResponse) {
        privacyPolicy = policyResponse.data;
        emit(PrivacyPolicyLoaded(policyResponse));
      },
    );
  }
}
