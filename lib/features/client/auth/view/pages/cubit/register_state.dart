import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/locations/data/model/location_model.dart';
import 'package:image_picker/image_picker.dart';

class RegisterState {}

final class RegisterInitial extends RegisterState {}

class RegisterStepChanged extends RegisterState {
  final int currentStep;
  RegisterStepChanged(this.currentStep);
}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  RegisterError({required this.message});
}

class RegisterDataUpdated extends RegisterState {
  final String? gender;
  final String? country;
  final String? governorate;
  final XFile? profileImage;
  final String? lat;
  final String? lng;
  final bool? rememberMe;
  RegisterDataUpdated({
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
  VerifyOtpSuccess(this.message);
}

class VerifyOtpError extends RegisterState {
  final String message;
  VerifyOtpError(this.message);
}

class LocationsLoading extends RegisterState {}

class CountriesLoaded extends RegisterState {
  final List<LocationModel> countries;
  CountriesLoaded(this.countries);
}

class StatesLoaded extends RegisterState {
  final List<LocationModel> states;
  StatesLoaded(this.states);
}

class CitiesLoaded extends RegisterState {
  final List<LocationModel> cities;
  CitiesLoaded(this.cities);
}

class LocationsError extends RegisterState {
  final String message;
  LocationsError(this.message);
}

class SetGenderState extends RegisterState {}

class CurrentStepUpdated extends RegisterState {
  final int step;
  CurrentStepUpdated(this.step);
}

class AgreeToTermsUpdated extends RegisterState {
  final bool agreeToTerms;
  AgreeToTermsUpdated(this.agreeToTerms);
}

class ResendOtpLoading extends RegisterState {}

class ResendOtpSuccess extends RegisterState {
  final String message;
  ResendOtpSuccess(this.message);
}

class ResendOtpError extends RegisterState {
  final String error;
  ResendOtpError(this.error);
}

class ContactsLoading extends RegisterState {}

class ContactsLoaded extends RegisterState {
  final List<ContactModel> contacts;
  ContactsLoaded(this.contacts);
}

class ContactsUpdated extends RegisterState {
  final List<ContactModel> contacts;
  ContactsUpdated(this.contacts);
}

class ContactsError extends RegisterState {
  final String message;
  ContactsError(this.message);
}

class ResendOtpTimerUpdated extends RegisterState {
  final int seconds;
  ResendOtpTimerUpdated(this.seconds);
}

class CheckingContactsLoading extends RegisterState {}

class ContactsChecked extends RegisterState {
  final List<User> registeredUsers;
  final List<ContactModel> nonRegisteredContacts;

  ContactsChecked(this.registeredUsers, this.nonRegisteredContacts);
}

class CheckingContactsError extends RegisterState {
  final String message;
  CheckingContactsError(this.message);
}

class VerifyPhoneNumber extends RegisterState {
  final String phoneNumber;

  VerifyPhoneNumber(this.phoneNumber);
}

class VerifyPhoneNumberLoading extends RegisterState {}

class VerifyPhoneNumberSuccess extends RegisterState {
  final String message;

  VerifyPhoneNumberSuccess(this.message);
}

class VerifyPhoneNumberError extends RegisterState {
  final String error;

  VerifyPhoneNumberError(this.error);
}

class VerifyEmail extends RegisterState {
  final String email;

  VerifyEmail(this.email);
}

class VerifyEmailLoading extends RegisterState {}

class VerifyEmailSuccess extends RegisterState {
  final String message;

  VerifyEmailSuccess(this.message);
}

class VerifyEmailError extends RegisterState {
  final String error;

  VerifyEmailError(this.error);
}

class LoadingContacts extends RegisterState {}

class LoaddedContacts extends RegisterState {}
