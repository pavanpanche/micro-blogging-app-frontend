import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetDetailScreen extends StatefulWidget {
  final int tweetId;
  final FeedApiService feedApiService;

  const TweetDetailScreen({
    super.key,
    required this.tweetId,
    required this.feedApiService,
  });

  @override
  State<TweetDetailScreen> createState() => _TweetDetailScreenState();
}

class _TweetDetailScreenState extends State<TweetDetailScreen> {
  late Future<Tweet> _tweetFuture;

  @override
  void initState() {
    super.initState();
    _tweetFuture = widget.feedApiService.getTweetById(widget.tweetId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tweet Detail")),
      body: FutureBuilder<Tweet>(
        future: _tweetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final tweet = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@${tweet.username}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeago.format(tweet.createdDate),
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(tweet.content, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(
                      tweet.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: tweet.isLiked ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text('${tweet.likeCount} Likes'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
