part of 'account_cubit.dart';

sealed class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

final class AccountInitial extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountSuccess extends AccountState {}

final class AccountError extends AccountState {
  final String massage;

  const AccountError({required this.massage});
}

class AccountUpdated extends AccountState {}

class CountriesLoaded extends AccountState {
  final List<LocationModel> countries;

  const CountriesLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class LocationsLoading extends AccountState {}

class LocationsError extends AccountState {
  final String message;

  const LocationsError(this.message);
}
