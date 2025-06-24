import 'package:embone/features/client/menu/data/model/privacy_policy_model.dart';

class PrivacyPolicyState {
  const PrivacyPolicyState();
}

final class PrivacyPolicyInitial extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final PrivacyPolicyResponse policyResponse;
  const PrivacyPolicyLoaded(this.policyResponse);
}

class PrivacyPolicyError extends PrivacyPolicyState {
  final String message;
  const PrivacyPolicyError(this.message);
}
