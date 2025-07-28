class FollowCount {
  final int followers;
  final int following;

  FollowCount({required this.followers, required this.following});

  factory FollowCount.fromJson(Map<String, dynamic> json) {
    return FollowCount(
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
    );
  }
}
