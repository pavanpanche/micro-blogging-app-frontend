import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/search_event.dart';
import 'package:subtxt_blog/bloc/search_state.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:subtxt_blog/services/user_api_service.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserApiService userApiService;
  final FeedApiService feedApiService;

  SearchBloc({required this.userApiService, required this.feedApiService})
    : super(SearchInitial()) {
    on<SearchUsers>(_onSearchUsers);
    on<SearchTweetsByKeyword>(_onSearchTweetsByKeyword);
    on<SearchTweetsByUsername>(_onSearchTweetsByUsername);
    on<ClearSearchResults>((event, emit) => emit(SearchInitial()));
  }

  //get user by username
  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await userApiService.searchUsers(query);
      emit(results.isEmpty ? SearchEmpty() : UserSearchResult(results));
    } catch (_) {
      emit(SearchError("Failed to search users."));
    }
  }

  Future<void> _onSearchTweetsByKeyword(
    SearchTweetsByKeyword event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await feedApiService.searchTweets(query);
      emit(results.isEmpty ? SearchEmpty() : TweetSearchResult(results));
    } catch (_) {
      emit(SearchError("Failed to search tweets by keyword."));
    }
  }

  Future<void> _onSearchTweetsByUsername(
    SearchTweetsByUsername event,
    Emitter<SearchState> emit,
  ) async {
    final username = event.username.trim();
    if (username.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final results = await feedApiService.getTweetsByUsername(username);
      emit(results.isEmpty ? SearchEmpty() : TweetSearchResult(results));
    } catch (_) {
      emit(SearchError("Failed to search tweets by username."));
    }
  }
}
