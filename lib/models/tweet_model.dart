class Tweet {
  final int id;
  final String content;
  final String username;
  final DateTime createdDate;
  int likeCount;
  bool isLiked;

  Tweet({
    required this.id,
    required this.content,
    required this.username,
    required this.createdDate,
    this.likeCount = 0,
    this.isLiked = false,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      content: json['content'],
      username: json['username'],
      createdDate: DateTime.parse(json['createdDate']),
      likeCount: json['likeCount'] ?? 0,
      isLiked: json['liked'] ?? false,
    );
  }
}
