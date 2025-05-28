class Follower {
  final String id;
  final String name;
  final String avatar;
  final bool isVerified;
  bool isFollowing;

  Follower({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isVerified,
    required this.isFollowing,
  });
}
