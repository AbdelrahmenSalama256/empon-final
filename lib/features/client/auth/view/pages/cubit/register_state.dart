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
