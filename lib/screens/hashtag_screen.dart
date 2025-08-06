import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/provider/tweet_provider.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';

class HashtagScreen extends StatefulWidget {
  final String hashtag;

  const HashtagScreen({super.key, required this.hashtag});

  @override
  State<HashtagScreen> createState() => _HashtagScreenState();
}

class _HashtagScreenState extends State<HashtagScreen> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TweetProvider>(
        context,
        listen: false,
      ).fetchTweetsByHashtag(widget.hashtag);
    });
  }

  Future<void> _loadUserId() async {
    final idStr = await _storage.read(key: 'id');
    if (mounted) {
      setState(() {
        _currentUserId = idStr != null ? int.tryParse(idStr) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = Provider.of<TweetProvider>(context);
    final likeProvider = Provider.of<LikeProvider>(context);
    final tweets = tweetProvider.tweets;

    return Scaffold(
      appBar: AppBar(title: Text("#${widget.hashtag}")),
      body: tweetProvider.isLoading || _currentUserId == null
          ? const Center(child: CircularProgressIndicator())
          : tweets.isEmpty
          ? const Center(child: Text('No tweets found.'))
          : ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                final tweet = tweets[index];
                return TweetCard(
                  tweet: tweet,
                  onTap: () {},
                  currentUserId: _currentUserId,
                  onLikePressed: () {
                    likeProvider.toggleLike(tweet.id);
                  },
                );
              },
            ),
    );
  }
}
