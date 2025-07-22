import 'package:embone/core/constants/widgets/print_util.dart';
import 'package:embone/features/client/chat/view/cubit/chat_state.dart';

class Message {
  final int id;
  bool fromMe;
  final MessageStatus status;
  final int senderId;
  final int receiverId;
  final String message;
  final String? mediaPath;
  final String mediaType;
  final Replay? replay;
  final String? replayId;
  final String createdAt;
  final int? voiceDuration;
  final int? voiceProgress;

  Message({
    required this.id,
    this.replayId,
    required this.fromMe,
    required this.senderId,
    required this.status,
    required this.receiverId,
    required this.message,
    this.mediaPath,
    required this.mediaType,
    this.replay,
    required this.createdAt,
    this.voiceDuration,
    this.voiceProgress,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    PrintUtil.debug(
        'Parsing message: from_me=${json['from_me']}, media_type=${json['media_type']}, media_path=${json['media_path']}');
    String mediaType = json['media_type'] as String? ?? 'text';

    // Infer mediaType from media_path if media_type is missing or incorrect
    if (json['media_path'] != null && mediaType == 'text') {
      final mediaPath = json['media_path'] as String;
      if (mediaPath.endsWith('.jpg') ||
          mediaPath.endsWith('.jpeg') ||
          mediaPath.endsWith('.png') ||
          mediaPath.endsWith('.gif')) {
        mediaType = 'image';
      } else if (mediaPath.endsWith('.aac') ||
          mediaPath.endsWith('.mp3') ||
          mediaPath.endsWith('.wav')) {
        mediaType = 'voice';
      }
    }

    return Message(
      id: _parseToInt(json['id']),
      fromMe: json['from_me'] as bool? ?? false,
      senderId: _parseToInt(json['sender_id']),
      receiverId: _parseToInt(json['receiver_id']),
      message: json['message'] as String? ?? '',
      mediaPath: json['media_path'] as String?,
      status: _parseStatus(json['status'], json['from_me'] as bool? ?? false),
      mediaType: mediaType,
      replay: json['replay'] != null
          ? Replay.fromJson(json['replay'] as Map<String, dynamic>)
          : null,
      replayId:
          json['replay_id'] as String? ?? (json['replay']?['id']?.toString()),
      createdAt: json['created_at'] as String? ?? '',
      voiceDuration: json['voice_duration'] as int?,
      voiceProgress: json['voice_progress'] as int?,
    );
  }
  static MessageStatus _parseStatus(dynamic status, bool fromMe) {
    if (status == null) {
      return fromMe ? MessageStatus.sent : MessageStatus.delivered;
    }
    switch (status.toString().toLowerCase()) {
      case 'sending':
        return MessageStatus.sending;
      case 'sent':
        return MessageStatus.sent;
      case 'failed':
        return MessageStatus.failed;
      case 'delivered':
        return MessageStatus.delivered;
      case 'read':
        return MessageStatus.read;
      case 'deleting':
        return MessageStatus.deleting;
      default:
        return fromMe ? MessageStatus.sent : MessageStatus.delivered;
    }
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
      'replay_id': replayId,
      'created_at': createdAt,
      'status': status.toString().split('.').last.toLowerCase(),
      'voice_duration': voiceDuration,
      'voice_progress': voiceProgress,
    };
  }

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Message copyWith({
    int? id,
    bool? fromMe,
    MessageStatus? status,
    int? senderId,
    int? receiverId,
    String? message,
    String? mediaPath,
    String? mediaType,
    Replay? replay,
    String? replayId,
    String? createdAt,
    int? voiceDuration,
    int? voiceProgress,
  }) {
    return Message(
      id: id ?? this.id,
      fromMe: fromMe ?? this.fromMe,
      status: status ?? this.status,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaType: mediaType ?? this.mediaType,
      replay: replay ?? this.replay,
      replayId: replayId ?? this.replayId,
      createdAt: createdAt ?? this.createdAt,
      voiceDuration: voiceDuration ?? this.voiceDuration,
      voiceProgress: voiceProgress ?? this.voiceProgress,
    );
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
      id: _parseToInt(json['id']),
      mediaType: json['media_type'] as String? ?? 'text',
      message: json['message'] as String? ?? '',
      mediaPath: json['media_path'] as String?,
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

  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
