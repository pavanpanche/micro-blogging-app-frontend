class Tweet {
  final int id;
  final String content;
  final String username;
  final DateTime createdDate;
  final int likeCount;
  final bool isLiked;

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

  get createdAt => null;

  /// ✅ Add this copyWith method
  Tweet copyWith({
    int? id,
    String? content,
    String? username,
    DateTime? createdDate,
    int? likeCount,
    bool? isLiked,
  }) {
    return Tweet(
      id: id ?? this.id,
      content: content ?? this.content,
      username: username ?? this.username,
      createdDate: createdDate ?? this.createdDate,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}
