import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart' as dio;
import 'package:embone/core/constants/widgets/errors/exceptions.dart';
import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/core/database/api/api_consumer.dart';
import 'package:embone/core/database/api/end_points.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/support_chat_conversation_model.dart';
import '../model/support_message_model.dart';

class SupportChatRepo {
  final ApiConsumer api;

  SupportChatRepo(this.api);

  Future<Either<String, SupportMessageResponseModel>> sendMessage({
    required String content,
    File? attachment,
  }) async {
    try {
      final formData = dio.FormData();

      formData.fields.addAll([
        if (content.isNotEmpty) MapEntry('message', content),
      ]);

      if (attachment != null) {
        formData.files.add(
          MapEntry(
            'attachment',
            await dio.MultipartFile.fromFile(
              attachment.path,
              filename: attachment.path.split('/').last,
            ),
          ),
        );
      }

      final response = await (api as dynamic).sendFormData(
        EndPoints.supportChat,
        formData: formData,
      );

      if (response['success'] == true) {
        final messageData = response['data'];
        return Right(SupportMessageResponseModel.fromJson({
          'success': true,
          'message': 'Message sent successfully',
          'data': messageData,
        }));
      } else {
        return Left(response['message'] ?? 'Failed to send message');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  Stream<List<SupportMessageModel>> getMessages(String rideId) {
    final chatRef = _database.child('chats/$rideId/messages');
    PrintUtil.debug("==================> chatRef: $chatRef");
    return chatRef.onValue.map((event) {
      PrintUtil.debug("==================> event: ${event.snapshot.value}");
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      PrintUtil.debug("==================> data: $data");

      if (data == null) return <SupportMessageModel>[];

      final messages = data.entries.map((entry) {
        final messageData = Map<String, dynamic>.from(entry.value);
        // Map Firebase fields to model fields
        messageData['id'] = entry.key; // Use Firebase key as ID
        messageData['supportConversationId'] = int.tryParse(rideId) ?? 0;
        messageData['senderType'] = messageData['sender_type'];
        messageData['senderId'] = messageData['sender_id'];
        messageData['mediaPath'] = messageData['media_path'];
        messageData['mediaType'] = messageData['media_type'] ?? 'text';
        messageData['updatedAt'] =
            messageData['updated_at'] ?? DateTime.now().toIso8601String();
        messageData['createdAt'] =
            messageData['created_at'] ?? DateTime.now().toIso8601String();
        messageData['status'] = messageData['status'] ?? 'delivered';
        return SupportMessageModel.fromFirebase(messageData,
            key: entry.key.toString());
      }).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
      PrintUtil.debug(
          "==================> Parsed messages: ${messages.length}");
      return messages;
    }).handleError((error) {
      PrintUtil.debug("==================> Firebase error: $error");
      throw error;
    });
  }

  Future<Either<String, List<SupportConversationModel>>> fetchMessages() async {
    try {
      final response = await api.get(EndPoints.supportChatGet);

      if (response.data['success'] == true) {
        final conversations = (response.data['data'] as List)
            .map((json) => SupportConversationModel.fromJson(json))
            .toList();
        return Right(conversations);
      } else {
        return Left(
            response.data['message'] ?? 'Failed to fetch conversations');
      }
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }
}
