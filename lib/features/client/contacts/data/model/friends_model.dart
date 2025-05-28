// embone/features/client/contacts/data/model/friends_model.dart
class FriendRequest {
  final int id;
  final String name;
  final String? image;
  final String status;
  final int isOnline;
  final String? lastSeen;
  final String createdAt;

  FriendRequest({
    required this.id,
    required this.name,
    this.image,
    required this.status,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      status: json['status'] ?? 'pending',
      isOnline: json['is_online'] ?? 0,
      lastSeen: json['last_seen'],
      createdAt: json['created_at'] ?? '',
    );
  }
}
