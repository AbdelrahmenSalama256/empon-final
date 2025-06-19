class ChatContact {
  final int id;
  final String name;
  final String? image;
  final String? lastSeen;
  final int isOnline;

  ChatContact({
    required this.id,
    required this.name,
    this.image,
    required this.isOnline,
    this.lastSeen,
  });

  factory ChatContact.fromJson(Map<String, dynamic> json) {
    return ChatContact(
      id: json['id'] ?? 0,
      image: json['image'],
      name: json['name'],
      isOnline: json['is_online'] ?? 0,
      lastSeen: json['last_seen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'is_online': isOnline,
      'last_seen': lastSeen,
    };
  }

  String get fullName => name;

  bool get isOnlineStatus => isOnline == 1;
}
