import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/feed_bloc.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';

import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FeedApiService feedApiService;

  int _currentPage = 0;
  bool _hasMore = true;
  final List<Tweet> _allTweets = [];

  FeedBloc({required this.feedApiService}) : super(FeedInitial()) {
    on<FetchFeed>(_onFetchFeed);
    on<FetchTweetById>(_onFetchTweetById);
    on<FetchAllTweets>(_onFetchAllTweets);
    on<CreateTweet>(_onCreateTweet);
    on<UpdateTweet>(_onUpdateTweet);
    on<RefreshTweet>(_onRefreshTweet); // <- renamed handler
    on<DeleteTweet>(_onDeleteTweet);
  }

  Future<void> _onFetchFeed(FetchFeed event, Emitter<FeedState> emit) async {
    if (event.reset) {
      _currentPage = 0;
      _hasMore = true;
      _allTweets.clear();
      emit(FeedLoading());
    }

    if (!_hasMore) return;

    try {
      final tweets = await feedApiService.fetchFeed(page: _currentPage);
      _hasMore = tweets.length >= 10;
      _allTweets.addAll(tweets);
      _currentPage++;

      emit(FeedLoaded(tweets: _allTweets, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onFetchAllTweets(
    FetchAllTweets event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedLoading());
    try {
      final tweets = await feedApiService.fetchAllTweets();
      emit(FeedLoaded(tweets: tweets, hasMore: false));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onCreateTweet(
    CreateTweet event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final newTweet = await feedApiService.createTweet(event.request);
      _allTweets.insert(0, newTweet);
      emit(FeedLoaded(tweets: _allTweets, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onUpdateTweet(
    UpdateTweet event,
    Emitter<FeedState> emit,
  ) async {
    try {
      final updated = await feedApiService.updateTweet(event.id, event.request);
      final index = _allTweets.indexWhere((t) => t.id == event.id);
      if (index != -1) {
        _allTweets[index] = updated;
      }
      emit(FeedLoaded(tweets: _allTweets, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  void _onRefreshTweet(RefreshTweet event, Emitter<FeedState> emit) {
    if (state is FeedLoaded) {
      final currentState = state as FeedLoaded;
      final updatedList = currentState.tweets.map((tweet) {
        return tweet.id == event.updatedTweet.id ? event.updatedTweet : tweet;
      }).toList();

      emit(FeedLoaded(tweets: updatedList, hasMore: currentState.hasMore));
    }
  }

  Future<void> _onDeleteTweet(
    DeleteTweet event,
    Emitter<FeedState> emit,
  ) async {
    try {
      await feedApiService.deleteTweet(event.id);
      _allTweets.removeWhere((t) => t.id == event.id);
      emit(FeedLoaded(tweets: _allTweets, hasMore: _hasMore));
    } catch (e) {
      emit(FeedError(e.toString()));
    }
  }

  Future<void> _onFetchTweetById(
    FetchTweetById event,
    Emitter<FeedState> emit,
  ) async {
    emit(FeedLoading());
    try {
      final tweet = await feedApiService.getTweetById(event.tweetId);
      emit(SingleTweetLoaded(tweet));
    } catch (e) {
      emit(SingleTweetError(e.toString()));
    }
  }
}
