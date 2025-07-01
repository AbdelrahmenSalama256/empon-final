import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/cubit/global_cubit.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:embone/core/services/service_locator.dart';
import 'package:embone/features/client/chat/data/model/chat_contact_model.dart';
import 'package:embone/features/client/chat/data/model/chat_details_model.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';

import '../../../../../core/database/api/dio_consumer.dart';

class ChatRepo {
  final ApiConsumer api;

  ChatRepo(this.api);
  Future<Either<String, List<ChatContact>>> getChatContacts() async {
    try {
      final response = await api.get(
        EndPoints.chatWith,
        isFormData: false,
      );

      if (response.data['success'] == true) {
        final List<dynamic> contactsData = response.data['data'] ?? [];
        final List<ChatContact> contacts = contactsData
            .map((e) => ChatContact.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(contacts);
      } else {
        return Left(response.data['message'] ?? 'Failed to fetch contacts');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

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

  Future<Either<String, Message>> sendMessage({
    required int receiverId,
    required String message,
    String? mediaType,
    File? media,
    String? replayId,
  }) async {
    try {
      final formData = FormData();

      formData.fields.addAll([
        MapEntry('receiver_id', receiverId.toString()),
        MapEntry('sender_id', sl<GlobalCubit>().userId.toString()),
        MapEntry('message', message),
        MapEntry('media_type', mediaType ?? 'text'),
        if (replayId != null) MapEntry('replay_id', replayId),
      ]);

      if (media != null && mediaType != 'text') {
        formData.files.add(
          MapEntry(
            'media',
            await MultipartFile.fromFile(
              media.path,
              filename: media.path.split('/').last,
            ),
          ),
        );
      }

      final response = await (api as DioConsumer).sendFormData(
        EndPoints.sendMessage,
        formData: formData,
      );

      if (response['success'] == true) {
        final messageData = response['data'];
        final sentMessage = Message.fromJson({
          ...messageData,
          'status': 'sent',
        });
        return Right(sentMessage.copyWith(
          fromMe: true,
          status: MessageStatus.sent,
        ));
      } else {
        return Left(response['message'] ?? 'Failed to send message');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, Message>> sendVoiceMessage({
    required int receiverId,
    required File voiceFile,
    String? replayId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'receiver_id': receiverId,
        'media_type': 'voice',
        if (replayId != null) 'replay_id': replayId,
        'voice': await MultipartFile.fromFile(
          voiceFile.path,
          filename:
              'voice_message_${DateTime.now().millisecondsSinceEpoch}.aac',
        ),
      });

      final response = await (api as DioConsumer).sendFormData(
        EndPoints.sendMessage,
        formData: formData,
      );

      if (response['success'] == true) {
        final messageData = response['data'];
        return Right(Message.fromJson(messageData));
      } else {
        return Left(response['message'] ?? 'Failed to send voice message');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> deleteMessage({required int messageId}) async {
    try {
      final response = await api.delete(
        '${EndPoints.deleteMessage}/$messageId', // Match the logged endpoint
      );

      if (response.data['success'] == true) {
        return Right(response.data['message'] as String); // "message_deleted"
      } else {
        return Left(response.data['message'] ?? 'Failed to delete message');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> deleteChat({required int receiveID}) async {
    try {
      final response = await api.delete(
        '${EndPoints.deleteChat}/$receiveID',
      );

      if (response.data['success'] == true) {
        return Right(response.data['message'] as String);
      } else {
        return Left(response.data['message'] ?? 'Failed to delete message');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
