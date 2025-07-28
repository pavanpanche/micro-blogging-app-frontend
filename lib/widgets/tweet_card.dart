import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final VoidCallback onLikePressed;
  final VoidCallback onTap;

  const TweetCard({
    super.key,
    required this.tweet,
    required this.onLikePressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${tweet.username}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                timeago.format(tweet.createdDate),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(tweet.content),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      tweet.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: tweet.isLiked ? Colors.red : Colors.grey,
                    ),
                    onPressed: onLikePressed,
                  ),
                  Text('${tweet.likeCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
