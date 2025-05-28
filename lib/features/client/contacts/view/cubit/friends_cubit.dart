import 'package:bloc/bloc.dart';
import 'package:embone/features/client/auth/data/models/user_data_model.dart';
import 'package:embone/features/client/contacts/data/model/contact_model.dart';
import 'package:embone/features/client/contacts/data/model/friends_model.dart';
import 'package:embone/features/client/contacts/data/repo/friends_repo.dart';
import 'package:embone/features/client/contacts/view/cubit/friends_state.dart';

class FriendsCubit extends Cubit<FriendsState> {
  final FriendsRepo friendsRepo;
  List<User> registeredUsers = [];
  List<ContactModel> nonRegisteredContacts = [];
  Map<String, FriendRequest?> friendRequests = {};
  List<FriendRequest> pendingFriendRequests = [];
  List<FriendRequest> acceptedFriends = [];
  FriendsCubit(this.friendsRepo) : super(FriendsInitial());
  void initializeContacts(List<User> users, List<ContactModel> nonRegistered) {
    registeredUsers = users;
    nonRegisteredContacts = nonRegistered;
    // Initialize friend request status for registered users
    for (var user in registeredUsers) {
      friendRequests[user.id.toString()] = null; // Initially no request
    }
    emit(FriendsLoaded());
  }

  Future<void> fetchFriendRequests() async {
    if (isClosed) return;

    emit(FriendsLoading());

    final response = await friendsRepo.fetchFriendRequests();

    if (isClosed) return;

    response.fold(
      (error) {
        emit(FriendsError(error));
      },
      (requests) {
        pendingFriendRequests = requests;
        emit(FriendsLoaded());
      },
    );
  }

  Future<void> acceptFriendRequest(String requestId) async {
    if (isClosed) return;

    emit(FriendsLoading());

    final response = await friendsRepo.acceptFriendRequest(requestId);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(FriendsError(error));
      },
      (message) {
        pendingFriendRequests
            .removeWhere((request) => request.id.toString() == requestId);
        emit(FriendRequestUpdated(message, null));
      },
    );
  }

  Future<void> declineFriendRequest(String requestId) async {
    if (isClosed) return;

    emit(FriendsLoading());

    final response = await friendsRepo.declineFriendRequest(requestId);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(FriendsError(error));
      },
      (message) {
        pendingFriendRequests
            .removeWhere((request) => request.id.toString() == requestId);
        emit(FriendRequestUpdated(message, null));
      },
    );
  }

  Future<void> toggleFriendRequest(String userId) async {
    if (isClosed) return;

    emit(FriendsLoading());

    final response = await friendsRepo.toggleFriendRequest(userId);

    if (isClosed) return;

    response.fold(
      (error) {
        emit(FriendsError(error));
      },
      (update) {
        friendRequests[userId] = update.friendRequest;
        emit(FriendRequestUpdated(update.message, update.friendRequest));
      },
    );
  }

  Future<void> fetchMyFriends() async {
    if (isClosed) return;

    emit(FriendsLoading());

    final response = await friendsRepo.fetchMyFriends();

    if (isClosed) return;

    response.fold(
      (error) {
        emit(FriendsError(error));
      },
      (friends) {
        acceptedFriends = friends;
        emit(FriendsLoaded());
      },
    );
  }

  String getFriendRequestStatus(String userId) {
    final request = friendRequests[userId];
    return request?.status ?? "none";
  }

  bool isUserSelected(String userId) {
    return getFriendRequestStatus(userId) == "pending";
  }
}
