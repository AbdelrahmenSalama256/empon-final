import 'package:flutter/foundation.dart';

class SupportMessageResponseModel {
  final bool success;
  final String message;
  final SupportMessageModel data;

  SupportMessageResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SupportMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: SupportMessageModel.fromJson(json['data']),
    );
  }
}

class SupportMessageModel {
  final int supportConversationId;
  final int senderId;
  final String senderType;
  final String content;
  final String? mediaPath;
  final String? mediaType;
  final String updatedAt;
  final String createdAt;
  final int id;
  final int timestamp;
  String? status;

  SupportMessageModel({
    required this.supportConversationId,
    required this.senderId,
    required this.senderType,
    required this.timestamp,
    required this.content,
    this.mediaPath,
    this.mediaType,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    this.status,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    return SupportMessageModel(
      supportConversationId: json['support_conversation_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      senderType: json['sender_type'] ?? '',
      content: json['content'] ?? '',
      mediaPath: json['media_path'],
      mediaType: json['media_type'],
      updatedAt: json['updated_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      id: json['id'] ?? 0,
      status: json['status'],
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory SupportMessageModel.fromFirebase(Map<String, dynamic> json,
      {String? key}) {
    if (kDebugMode) {
      print('Parsing message: $json');
    }
    return SupportMessageModel(
      id: key != null ? int.tryParse(key) ?? 0 : 0,
      supportConversationId: 0,
      senderId: json['sender_id'] ?? 0,
      senderType: json['sender_type'] ?? '',
      content: json['content'] ?? '',
      mediaPath: json['media_path'],
      mediaType: json['media_type'] ?? 'text',
      updatedAt: json['updated_at'] ?? DateTime.now().toIso8601String(),
      createdAt: json['created_at'] ?? DateTime.now().toIso8601String(),
      status: json['status'] ?? 'delivered',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
  SupportMessageModel copyWith({
    int? supportConversationId,
    int? senderId,
    String? senderType,
    String? content,
    String? mediaPath,
    String? mediaType,
    String? updatedAt,
    String? createdAt,
    int? id,
    String? status,
    int? timestamp,
  }) {
    return SupportMessageModel(
      supportConversationId:
          supportConversationId ?? this.supportConversationId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      content: content ?? this.content,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
