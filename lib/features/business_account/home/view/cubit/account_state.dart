part of 'account_cubit.dart';

class BusinessAccountState {
  const BusinessAccountState();
}

class BusinessAccountInitial extends BusinessAccountState {}

class BusinessAccountLoading extends BusinessAccountState {}

class BusinessAccountLoaded extends BusinessAccountState {
  final BusinessAccountResponse data;

  const BusinessAccountLoaded(this.data);
}

class BusinessAccountError extends BusinessAccountState {
  final String message;

  const BusinessAccountError(this.message);
}
