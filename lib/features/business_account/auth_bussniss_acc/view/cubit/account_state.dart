import '../../../../client/locations/data/model/location_model.dart';

class AccountState {}

final class AccountInitial extends AccountState {}

final class AccountLoading extends AccountState {}

final class AccountSuccess extends AccountState {}

final class AccountError extends AccountState {
  final String massage;

  AccountError({required this.massage});
}

class AccountUpdated extends AccountState {}

class CountriesLoaded extends AccountState {
  final List<LocationModel> countries;

  CountriesLoaded(this.countries);
}

class LocationsLoading extends AccountState {}

class LocationsError extends AccountState {
  final String message;

  LocationsError(this.message);
}

class AccountStepOneCompleted extends AccountState {}
class StatesLoaded extends AccountState {
  final List<LocationModel> states;
  StatesLoaded(this.states);
}

class CitiesLoaded extends AccountState {
  final List<LocationModel> cities;
  CitiesLoaded(this.cities);
}
