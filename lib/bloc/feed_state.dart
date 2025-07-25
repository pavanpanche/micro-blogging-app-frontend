import 'package:subtxt_blog/models/tweet_model.dart';

abstract class FeedState {}

class FeedInitial extends FeedState {}

class FeedLoading extends FeedState {}

class FeedLoaded extends FeedState {
  final List<Tweet> tweets;
  final bool hasMore;

  FeedLoaded({required this.tweets, required this.hasMore});
}

class FeedError extends FeedState {
  final String message;
  FeedError(this.message);
}

/// Optional: You can use these if you want to show success feedback in UI

class TweetCreated extends FeedState {
  final Tweet tweet;
  TweetCreated(this.tweet);
}

class TweetUpdated extends FeedState {
  final Tweet tweet;
  TweetUpdated(this.tweet);
}

class TweetDeleted extends FeedState {
  final int id;
  TweetDeleted(this.id);
}

class SingleTweetLoaded extends FeedState {
  final Tweet tweet;
  SingleTweetLoaded(this.tweet);
}

class SingleTweetError extends FeedState {
  final String message;
  SingleTweetError(this.message);
}
