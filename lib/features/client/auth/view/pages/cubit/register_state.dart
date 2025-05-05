part of 'register_cubit.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

class RegisterStepChanged extends RegisterState {
  final int currentStep;

  const RegisterStepChanged(this.currentStep);
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;

  const RegisterError({required this.message});
}

class RegisterDataUpdated extends RegisterState {
  final String? gender;
  final String? country;
  final String? governorate;
  final XFile? profileImage;
  final String? lat;
  final String? lng;
  final bool? rememberMe;

  const RegisterDataUpdated({
    this.gender,
    this.country,
    this.governorate,
    this.profileImage,
    this.lat,
    this.lng,
    this.rememberMe,
  });
}

class VerifyOtpLoading extends RegisterState {}

class VerifyOtpSuccess extends RegisterState {
  final String message;

  const VerifyOtpSuccess(this.message);
}

class VerifyOtpError extends RegisterState {
  final String message;

  const VerifyOtpError(this.message);
}

class LocationsLoading extends RegisterState {}

class CountriesLoaded extends RegisterState {
  final List<LocationModel> countries;

  const CountriesLoaded(this.countries);
}

class StatesLoaded extends RegisterState {
  final List<LocationModel> states;

  const StatesLoaded(this.states);
}

class CitiesLoaded extends RegisterState {
  final List<LocationModel> cities;

  const CitiesLoaded(this.cities);
}

class LocationsError extends RegisterState {
  final String message;

  const LocationsError(this.message);
}

class SetGenderState extends RegisterState {}

class CurrentStepUpdated extends RegisterState {
  final int step;
  const CurrentStepUpdated(this.step);
}

class AgreeToTermsUpdated extends RegisterState {
  final bool agreeToTerms;
  const AgreeToTermsUpdated(this.agreeToTerms);
}

class ResendOtpLoading extends RegisterState {}

class ResendOtpSuccess extends RegisterState {
  final String message;

  const ResendOtpSuccess(this.message);
}

class ResendOtpError extends RegisterState {
  final String error;

  const ResendOtpError(this.error);
}
