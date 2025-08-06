class LikeResponse {
  final int tweetId;
  final int userId;
  final String username;
  final bool likedByCurrentUser;
  final int totalLikes;

  LikeResponse({
    required this.tweetId,
    required this.userId,
    required this.username,
    required this.likedByCurrentUser,
    required this.totalLikes,
  });

  factory LikeResponse.fromJson(Map<String, dynamic> json) {
    return LikeResponse(
      tweetId: json['tweetId'],
      userId: json['userId'],
      username: json['username'],
      likedByCurrentUser: json['likedByCurrentUser'],
      totalLikes: json['totalLikes'],
    );
  }
}
