import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/contacts/data/model/friends_model.dart';

class FriendsRepo {
  final ApiConsumer api;

  FriendsRepo(this.api);
  Future<Either<String, FriendRequestUpdate>> toggleFriendRequest(
      String userId) async {
    try {
      final response = await api.post(
        EndPoints.addFriend,
        data: {
          'receiver_id': userId,
        },
      );
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final message =
            response.data['message'] ?? 'Action completed successfully';
        if (response.data['data'] != null) {
          final friendRequest = FriendRequest.fromJson(response.data['data']);
          return Right(FriendRequestUpdate(
              message: message, friendRequest: friendRequest));
        } else {
          // Friend request canceled
          return Right(
              FriendRequestUpdate(message: message, friendRequest: null));
        }
      } else {
        return Left(
            response.data['message'] ?? 'Failed to process friend request');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  Future<Either<String, List<FriendRequest>>> fetchFriendRequests() async {
    try {
      final response = await api.get(EndPoints.friendRequests);
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        final friendRequests =
            data.map((json) => FriendRequest.fromJson(json)).toList();
        return Right(friendRequests);
      } else {
        return Left(
            response.data['message'] ?? 'Failed to fetch friend requests');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  Future<Either<String, String>> acceptFriendRequest(String requestId) async {
    try {
      final response = await api.post(
        "${EndPoints.acceptFriendRequest}/$requestId/respond",
        data: {'status': "accepted"},
      );
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        return Right(
            response.data['message'] ?? 'Friend request accepted successfully');
      } else {
        return Left(
            response.data['message'] ?? 'Failed to accept friend request');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  Future<Either<String, String>> declineFriendRequest(String requestId) async {
    try {
      final response = await api.post(
        "${EndPoints.declineFriendRequest}/$requestId/respond",
        data: {'status': "rejected"},
      );
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        return Right(
            response.data['message'] ?? 'Friend request declined successfully');
      } else {
        return Left(
            response.data['message'] ?? 'Failed to decline friend request');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }

  Future<Either<String, List<FriendRequest>>> fetchMyFriends() async {
    try {
      final response = await api.get(EndPoints.myFriends);
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        final friends =
            data.map((json) => FriendRequest.fromJson(json)).toList();
        return Right(friends);
      } else {
        return Left(response.data['message'] ?? 'Failed to fetch friends');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('An unexpected error occurred: $e');
    }
  }
}

class FriendRequestUpdate {
  final String message;
  final FriendRequest? friendRequest;

  FriendRequestUpdate({required this.message, this.friendRequest});
}
