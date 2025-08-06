import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/provider/tweet_provider.dart';
import 'package:subtxt_blog/screens/tweet_details_screen.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';
import 'package:subtxt_blog/widgets/create_tweet_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _hashtagController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final tweetProvider = context.read<TweetProvider>();
    tweetProvider.fetchUserFeed();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          tweetProvider.hasMore &&
          !tweetProvider.isLoading) {
        tweetProvider.fetchNextFeedPage();
      }
    });
  }

  @override
  void dispose() {
    _hashtagController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchHashtag() {
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

    return Scaffold(
      appBar: AppBar(title: const Text("Your Feed")),
      body: Column(
        children: [
          const CreateTweetCard(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _hashtagController,
                    decoration: const InputDecoration(
                      hintText: 'Enter hashtag (e.g. flutter)',
                      prefixText: '#',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onSubmitted: (_) => _onSearchHashtag(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _onSearchHashtag,
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading && tweets.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : tweets.isEmpty
                ? const Center(child: Text("No tweets available."))
                : RefreshIndicator(
                    onRefresh: () => tweetProvider.fetchUserFeed(),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: tweetProvider.hasMore
                          ? tweets.length + 1
                          : tweets.length,
                      itemBuilder: (context, index) {
                        if (index == tweets.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final tweet = tweets[index];

                        return TweetCard(
                          tweet: tweet,
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
                          currentUserId: tweet.userId,
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
