import 'support_message_model.dart';

class SupportConversationModel {
  final int id;
  final int userId;
  final int? adminId;
  final String subject;
  final int isClosed;
  final String lastMessageAt;
  final String createdAt;
  final String updatedAt;
  final List<SupportMessageModel> messages;

  SupportConversationModel({
    required this.id,
    required this.userId,
    this.adminId,
    required this.subject,
    required this.isClosed,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
  });

  factory SupportConversationModel.fromJson(Map<String, dynamic> json) {
    return SupportConversationModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      adminId: json['admin_id'],
      subject: json['subject'] ?? '',
      isClosed: json['is_closed'] ?? 0,
      lastMessageAt: json['last_message_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((item) => SupportMessageModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  SupportConversationModel copyWith({
    int? id,
    int? userId,
    int? adminId,
    String? subject,
    int? isClosed,
    String? lastMessageAt,
    String? createdAt,
    String? updatedAt,
    List<SupportMessageModel>? messages,
  }) {
    return SupportConversationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      adminId: adminId ?? this.adminId,
      subject: subject ?? this.subject,
      isClosed: isClosed ?? this.isClosed,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }
}
