abstract class SearchEvent {}

class SearchUsers extends SearchEvent {
  final String query;
  SearchUsers(this.query);
}

class SearchTweetsByKeyword extends SearchEvent {
  final String query;
  SearchTweetsByKeyword(this.query);
}

class SearchTweetsByUsername extends SearchEvent {
  final String username;
  SearchTweetsByUsername(this.username);
}

class ClearSearchResults extends SearchEvent {}
