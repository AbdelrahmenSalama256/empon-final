import 'package:dartz/dartz.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';

class ChatRepo {
  final ApiConsumer api;

  ChatRepo(this.api);

  Future<Either<String, List<Message>>> getMessages({
    required int receiverId,
  }) async {
    try {
      final response = await api.get(
        '${EndPoints.chatMessages}/$receiverId',
        isFormData: false,
      );

      if (response.data['success'] == true) {
        final List<dynamic> messagesData = response.data['data'] ?? [];
        final List<Message> messages = messagesData
            .map((e) => Message.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(messages);
      } else {
        return Left(response.data['message'] ?? 'Failed to fetch messages');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
