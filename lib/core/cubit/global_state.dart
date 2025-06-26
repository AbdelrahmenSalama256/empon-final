import '../../features/client/auth/data/models/user_data_model.dart';

class GlobalState {}

final class GlobalInitial extends GlobalState {}

final class BottomNavChangeState extends GlobalState {}

// Any Other State You May Need
class LoadingState extends GlobalState {}

class ErrorState extends GlobalState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}

class LanguageChangeState extends GlobalState {}

class UserTypeLoadedState extends GlobalState {}

class UserTypeChangedState extends GlobalState {}

class ProfileLoading extends GlobalState {}

class ProfileLoaded extends GlobalState {}

class ProfileError extends GlobalState {
  final String message;

  ProfileError(this.message);
}

class LogoutLoading extends GlobalState {}

class LogoutSuccess extends GlobalState {
  final String message;

  LogoutSuccess(this.message);
}

class LogoutError extends GlobalState {
  final String message;

  LogoutError(this.message);
}

class ProfileDataUpdated extends GlobalState {}

class ProfileUpdated extends GlobalState {}

class WishlistLoading extends GlobalState {}

class WishlistSuccess extends GlobalState {
  final String message;
  WishlistSuccess(this.message);
}

class WishlistError extends GlobalState {
  final String message;

  WishlistError(this.message);
}

class GetAddressLoading extends GlobalState {}

class GetAddressSuccess extends GlobalState {
  final List<Address> addresses;

  GetAddressSuccess(this.addresses);
}

class GetAddressError extends GlobalState {
  final String message;

  GetAddressError(this.message);
}

class AddressLoading extends GlobalState {}

class AddressSuccess extends GlobalState {}

class AddressError extends GlobalState {
  final String message;
  AddressError(this.message);
}

class FollowAccountLoading extends GlobalState {}

class FollowAccountSuccess extends GlobalState {
  final String message;
  FollowAccountSuccess(this.message);
}

class FollowAccountError extends GlobalState {
  final String message;

  FollowAccountError(this.message);
}
