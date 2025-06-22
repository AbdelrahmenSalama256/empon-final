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
      // سجل الاستجابة
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          final nestedData = data['data'];
          List<dynamic> friendData;
          if (nestedData == null) {
            friendData = [];
          } else if (nestedData is List<dynamic>) {
            friendData = nestedData;
          } else if (nestedData is Map<String, dynamic>) {
            friendData = [nestedData];
          } else {
            return const Left(
                'Invalid data format in friend requests response');
          }
          final friendRequests = friendData
              .map((json) => FriendRequest.fromJson(json))
              .where((request) => request.id != null) // فلترة القيم الفارغة
              .toList();
          return Right(friendRequests);
        } else {
          return const Left('Invalid response format: expected data object');
        }
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

  Future<Either<String, List<Friend>>> fetchMyFriends() async {
    try {
      final response = await api.get(EndPoints.myFriends);
      // سجل الاستجابة
      if (response.data is Map<String, dynamic> &&
          response.data['success'] == true) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          final nestedData = data['data'];
          List<dynamic> friendData;
          if (nestedData == null) {
            friendData = [];
          } else if (nestedData is List<dynamic>) {
            friendData = nestedData;
          } else if (nestedData is Map<String, dynamic>) {
            friendData = [nestedData];
          } else {
            return const Left('Invalid data format in friends response');
          }
          final friends = friendData
              .map((json) => Friend.fromJson(json))
              .where((friend) => friend.id != null) // فلترة القيم الفارغة
              .toList();
          return Right(friends);
        } else {
          return const Left('Invalid response format: expected data object');
        }
      } else {
        return Left(response.data['message'] ?? 'Failed to fetch friends');
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
}
