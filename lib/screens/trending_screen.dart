import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/provider/tweet_provider.dart';
import 'package:subtxt_blog/screens/tweet_details_screen.dart';
import 'package:subtxt_blog/services/tweet_api_serivce.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';

class TrendingScreen extends StatefulWidget {
  final TweetApiService tweetApiService;

  const TrendingScreen({super.key, required this.tweetApiService});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final TextEditingController _hashtagController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int? currentUserId;

  @override
  void initState() {
    super.initState();

    final tweetProvider = context.read<TweetProvider>();
    tweetProvider.setService(widget.tweetApiService);

    _loadUserId();

    Future.microtask(() {
      tweetProvider.fetchRecentTweets();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          tweetProvider.hasMore &&
          !tweetProvider.isLoading) {
        tweetProvider.fetchNextFeedPage();
      }
    });
  }

  Future<void> _loadUserId() async {
    const storage = FlutterSecureStorage();
    final idStr = await storage.read(key: 'userId');
    if (idStr != null) {
      setState(() {
        currentUserId = int.tryParse(idStr);
      });
    }
  }

  @override
  void dispose() {
    _hashtagController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _searchHashtag() {
    final tag = _hashtagController.text.trim();
    if (tag.isNotEmpty) {
      context.read<TweetProvider>().fetchTweetsByHashtag(tag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tweetProvider = context.watch<TweetProvider>();
    final likeProvider = context.watch<LikeProvider>();

    final tweets = tweetProvider.tweets;
    final isLoading = tweetProvider.isLoading;
    final hasMore = tweetProvider.hasMore;

    return Scaffold(
      appBar: AppBar(title: const Text("Trending")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hashtagController,
                    decoration: const InputDecoration(
                      hintText: "#hashtag",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _searchHashtag(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchHashtag,
                  child: const Text("Search"),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading && tweets.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<TweetProvider>().fetchRecentTweets(),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: tweets.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= tweets.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final tweet = tweets[index];

                        return TweetCard(
                          tweet: tweet,
                          currentUserId: currentUserId,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TweetDetailScreen(tweetId: tweet.id),
                              ),
                            );
                          },
                          onLikePressed: () async {
                            final response = await likeProvider.toggleLike(
                              tweet.id,
                            );
                            if (response != null) {
                              final updatedTweet = tweet.copyWith(
                                isLiked: response.likedByCurrentUser,
                                likeCount: response.totalLikes,
                              );
                              tweetProvider.updateTweetInList(
                                index,
                                updatedTweet,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
