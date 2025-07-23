import '../../features/client/auth/data/models/user_data_model.dart';
import 'global_cubit.dart';

class GlobalState {
  final String? userId;
  final int? businessId;
  final UserType userType;
  final bool isNotificationsDisabled;
  final String language;
  final int currentBottomNavIndex;
  final int unreadMessageCount;
  final int unreadNotificationCount;

  const GlobalState({
    this.userId,
    this.businessId,
    this.userType = UserType.client,
    this.isNotificationsDisabled = false,
    this.language = 'en',
    this.currentBottomNavIndex = 0,
    this.unreadMessageCount = 0,
    this.unreadNotificationCount = 0,
  });

  GlobalState copyWith({
    String? userId,
    int? businessId,
    UserType? userType,
    bool? isNotificationsDisabled,
    String? language,
    int? currentBottomNavIndex,
    int? unreadNotificationCount,
    int? unreadMessageCount,
  }) {
    return GlobalState(
      userId: userId ?? this.userId,
      businessId: businessId ?? this.businessId,
      userType: userType ?? this.userType,
      isNotificationsDisabled:
          isNotificationsDisabled ?? this.isNotificationsDisabled,
      language: language ?? this.language,
      currentBottomNavIndex:
          currentBottomNavIndex ?? this.currentBottomNavIndex,
      unreadMessageCount: unreadMessageCount ?? this.unreadMessageCount,
      unreadNotificationCount:
          unreadNotificationCount ?? this.unreadNotificationCount,
    );
  }
}

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

class AccountDeletedSuccess extends GlobalState {
  final String message;
  AccountDeletedSuccess(this.message);
}

class UserTypeSwitchingState extends GlobalState {}
