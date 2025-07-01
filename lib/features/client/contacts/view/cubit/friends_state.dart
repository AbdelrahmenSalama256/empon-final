import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/contacts/data/model/friends_model.dart';

class FriendsState {
  const FriendsState();
}

final class FriendsInitial extends FriendsState {}

final class FriendsLoading extends FriendsState {}

final class FriendsError extends FriendsState {
  final String error;
  FriendsError(this.error);
}

final class FriendAddedSuccess extends FriendsState {
  final String message;
  FriendAddedSuccess(this.message);
}

final class FriendsRefreshed extends FriendsState {}

class FriendsLoaded extends FriendsState {
  final List<User>? registeredUsers;
  final List<ContactModel>? nonRegisteredContacts;

  FriendsLoaded({
    this.registeredUsers,
    this.nonRegisteredContacts,
  });
}

final class FriendRequestUpdated extends FriendsState {
  final String message;
  final FriendRequest? friendRequest;

  const FriendRequestUpdated(this.message, this.friendRequest);
}

class FriendsLoadingMore extends FriendsState {} // New state
