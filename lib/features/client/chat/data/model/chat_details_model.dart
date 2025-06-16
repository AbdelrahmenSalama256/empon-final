// embone/features/client/chat/data/model/message_model.dart
class Message {
  final int id;
  final bool fromMe;
  final int senderId;
  final int receiverId;
  final String message;
  final String? mediaPath;
  final String mediaType;
  final Replay? replay;
  final String createdAt;

  Message({
    required this.id,
    required this.fromMe,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.mediaPath,
    required this.mediaType,
    this.replay,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? 0,
      fromMe: json['from_me'] ?? false,
      senderId: json['sender_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      message: json['message'] ?? '',
      mediaPath: json['media_path'],
      mediaType: json['media_type'] ?? 'text',
      replay: json['replay'] != null ? Replay.fromJson(json['replay']) : null,
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from_me': fromMe,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'media_path': mediaPath,
      'media_type': mediaType,
      'replay': replay?.toJson(),
      'created_at': createdAt,
    };
  }
}

class Replay {
  final int id;
  final String mediaType;
  final String message;
  final String? mediaPath;

  Replay({
    required this.id,
    required this.mediaType,
    required this.message,
    this.mediaPath,
  });

  factory Replay.fromJson(Map<String, dynamic> json) {
    return Replay(
      id: json['id'] ?? 0,
      mediaType: json['media_type'] ?? 'text',
      message: json['message'] ?? '',
      mediaPath: json['media_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'message': message,
      'media_path': mediaPath,
    };
  }
}
