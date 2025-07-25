import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/models/tweet_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class UserSearchResult extends SearchState {
  final List<UserSearch> users;
  UserSearchResult(this.users);
}

class TweetSearchResult extends SearchState {
  final List<Tweet> tweets;
  TweetSearchResult(this.tweets);
}

class SearchEmpty extends SearchState {}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
