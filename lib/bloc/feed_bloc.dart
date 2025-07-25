import 'package:subtxt_blog/models/tweet_request.dart';
import 'package:subtxt_blog/models/tweet_model.dart';

abstract class FeedEvent {}

class FetchFeed extends FeedEvent {
  final bool reset;
  FetchFeed({this.reset = false});
}

class FetchAllTweets extends FeedEvent {}

class CreateTweet extends FeedEvent {
  final TweetRequest request;
  CreateTweet(this.request);
}

class UpdateTweet extends FeedEvent {
  final int id;
  final TweetRequest request;
  UpdateTweet(this.id, this.request);
}

class RefreshTweet extends FeedEvent {
  // renamed to avoid conflict
  final Tweet updatedTweet;
  RefreshTweet(this.updatedTweet);
}

class DeleteTweet extends FeedEvent {
  final int id;
  DeleteTweet(this.id);
}

class FetchTweetById extends FeedEvent {
  final int tweetId;
  FetchTweetById(this.tweetId);
}
