class Tweet {
  final int id;
  final String content;
  final String username;
  final DateTime createdAt;
  final int userId;
  final int? likeCount;
  final bool? isLiked;
  final List<String>? hashtags;

  Tweet({
    required this.id,
    required this.content,
    required this.username,
    required this.createdAt,
    required this.userId,
    this.likeCount,
    this.isLiked,
    this.hashtags,
  });

  factory Tweet.fromJson(Map<String, dynamic> json) {
    return Tweet(
      id: json['id'],
      content: json['content'],
      username: json['username'],
      userId: json['userId'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'],
      isLiked: json['isLiked'],
      hashtags: List<String>.from(json['hashtags'] ?? []),
    );
  }

  Tweet copyWith({
    int? id,
    String? content,
    String? username,
    DateTime? createdAt,
    int? userId,
    int? likeCount,
    bool? isLiked,
    List<String>? hashtags,
  }) {
    return Tweet(
      id: id ?? this.id,
      content: content ?? this.content,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      hashtags: hashtags ?? this.hashtags,
    );
  }
}
