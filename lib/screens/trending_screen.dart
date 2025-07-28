import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/feed_bloc.dart';
import 'package:subtxt_blog/bloc/feed_event.dart';
import 'package:subtxt_blog/bloc/feed_state.dart';
import 'package:subtxt_blog/screens/tweet_details_screen.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';

class TrendingScreen extends StatefulWidget {
  final FeedApiService feedApiService;

  const TrendingScreen({super.key, required this.feedApiService});

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(FetchRecentTweets(reset: true));

    _scrollController.addListener(() {
      final bloc = context.read<FeedBloc>();
      final state = bloc.state;
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          state is RecentTweetLoaded &&
          state.hasMore) {
        bloc.add(FetchRecentTweets());
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onLikePressed(Tweet tweet) {
    final updatedTweet = tweet.copyWith(
      isLiked: !tweet.isLiked,
      likeCount: tweet.isLiked ? tweet.likeCount - 1 : tweet.likeCount + 1,
    );
    context.read<FeedBloc>().add(RefreshTweet(updatedTweet));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is FeedLoading || state is FeedInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FeedError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is RecentTweetLoaded) {
          final tweets = state.tweets;

          if (tweets.isEmpty) {
            return const Center(child: Text("No trending tweets found."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<FeedBloc>().add(FetchRecentTweets(reset: true));
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: tweets.length + 1,
              itemBuilder: (context, index) {
                if (index == tweets.length) {
                  return state.hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

                final tweet = tweets[index];
                return TweetCard(
                  tweet: tweet,
                  onLikePressed: () => _onLikePressed(tweet),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TweetDetailScreen(
                          tweetId: tweet.id,
                          feedApiService: widget.feedApiService,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        }

        return const Center(child: Text("Unknown state"));
      },
    );
  }
}
