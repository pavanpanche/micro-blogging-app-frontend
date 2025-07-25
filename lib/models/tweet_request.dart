class TweetRequest {
  final String content;

  TweetRequest({required this.content});

  Map<String, dynamic> toJson() => {'content': content};
}
