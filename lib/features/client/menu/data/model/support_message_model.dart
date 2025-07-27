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
  String? status; // Added for status tracking

  SupportMessageModel({
    required this.supportConversationId,
    required this.senderId,
    required this.senderType,
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
      status: json['status'], // Added status from JSON
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
  }) {
    return SupportMessageModel(
      supportConversationId: supportConversationId ?? this.supportConversationId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      content: content ?? this.content,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      status: status ?? this.status,
    );
  }
}