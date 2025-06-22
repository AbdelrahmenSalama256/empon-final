class FriendRequestUpdate {
  final String message;
  final FriendRequest? friendRequest;

  FriendRequestUpdate({required this.message, this.friendRequest});
}

class FriendRequest {
  final int? id;
  final int? senderId;
  final int? receiverId;
  final String? name;
  final String? image;
  final String? status;
  final int? isOnline;
  final String? lastSeen;
  final String? createdAt;

  FriendRequest({
    this.id,
    this.senderId,
    this.receiverId,
    this.name,
    this.image,
    this.status,
    this.isOnline,
    this.lastSeen,
    this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] as int?,
      senderId: json['sender_id'] as int?,
      receiverId: json['receiver_id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
      isOnline: json['is_online'] as int?,
      lastSeen: json['last_seen'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}

class Friend {
  final int? id;
  final String? name;
  final String? image;
  final String? status;
  final int? isOnline;
  final String? lastSeen;
  final bool? isFriend;

  Friend({
    this.id,
    this.name,
    this.image,
    this.status,
    this.isOnline,
    this.lastSeen,
    this.isFriend,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      status: json['status'] as String?,
      isOnline: json['is_online'] as int?,
      lastSeen: json['last_seen'] as String?,
      isFriend: json['is_friend'] as bool?,
    );
  }
}
