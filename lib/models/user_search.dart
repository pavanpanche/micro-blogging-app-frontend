class UserSearch {
  final String username;
  final int followerCount;
  final int followingCount;

  UserSearch({
    required this.username,
    required this.followerCount,
    required this.followingCount,
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      username: json['username'],
      followerCount: json['followerCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'followerCount': followerCount,
      'followingCount': followingCount,
    };
  }
}
