import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/feed_bloc.dart';
import 'package:subtxt_blog/bloc/feed_event.dart';
import 'package:subtxt_blog/bloc/feed_state.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:subtxt_blog/services/like_api_service.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';

class FeedScreen extends StatelessWidget {
  final FeedApiService feedApiService;
  final LikeApiService likeApiService;

  const FeedScreen({
    super.key,
    required this.feedApiService,
    required this.likeApiService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          FeedBloc(feedApiService: feedApiService)..add(FetchFeed(reset: true)),
      child: BlocBuilder<FeedBloc, FeedState>(
        builder: (context, state) {
          if (state is FeedLoading || state is FeedInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FeedError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is FeedLoaded) {
            final tweets = state.tweets;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<FeedBloc>().add(FetchFeed(reset: true));
              },
              child: ListView.builder(
                itemCount: tweets.length,
                itemBuilder: (context, index) {
                  final tweet = tweets[index];

                  return TweetCard(
                    tweet: tweet,
                    onLikePressed: () async {
                      final liked = await likeApiService.toggleLike(tweet.id);
                      final likeCount = await likeApiService.getLikeCount(
                        tweet.id,
                      );

                      // create a new updated tweet
                      final updatedTweet = tweet.copyWith(
                        isLiked: liked,
                        likeCount: likeCount,
                      );

                      // replace the tweet in the list
                      final updatedTweets = List<Tweet>.from(tweets);
                      updatedTweets[index] = updatedTweet;

                      // update the BLoC state
                      context.read<FeedBloc>().add(
                        UpdateTweetList(updatedTweets),
                      );
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox(); // fallback
        },
      ),
    );
  }
}
