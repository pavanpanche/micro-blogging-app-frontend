import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/services/tweet_api_serivce.dart';
import 'package:subtxt_blog/services/user_api_service.dart';

enum SearchType { none, tweet, user }

class SearchProvider with ChangeNotifier {
  final UserApiService _userApiService;
  final TweetApiService _tweetApiService;

  SearchProvider({
    required UserApiService userApiService,
    required TweetApiService tweetApiService,
  }) : _userApiService = userApiService,
       _tweetApiService = tweetApiService;

  bool _isLoading = false;
  String _errorMessage = '';
  SearchType _currentSearchType = SearchType.none;

  List<UserSearch> _searchedUsers = [];
  List<Tweet> _searchedTweets = [];

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  SearchType get currentSearchType => _currentSearchType;
  List<UserSearch> get searchedUsers => _searchedUsers;
  List<Tweet> get searchedTweets => _searchedTweets;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _setSearchType(SearchType type) {
    _currentSearchType = type;
    notifyListeners();
  }

  // === User Search ===
  Future<void> searchUsers(String username) async {
    _setLoading(true);
    _setSearchType(SearchType.user);
    try {
      _searchedUsers = await _userApiService.searchUsers(username);
      _errorMessage = '';
    } catch (e) {
      _searchedUsers = [];
      _setError("Failed to load users");
      debugPrint("User search error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Tweet Search ===
  Future<void> searchTweetsByKeyword(String keyword) async {
    _setLoading(true);
    _setSearchType(SearchType.tweet);
    try {
      _searchedTweets = await _tweetApiService.searchTweets(keyword);
      _errorMessage = '';
    } catch (e) {
      _searchedTweets = [];
      _setError("Failed to search tweets");
      debugPrint("Tweet search error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Tweets by Hashtag (optional use) ===
  Future<void> fetchTweetsByHashtag(String tag) async {
    _setLoading(true);
    _setSearchType(SearchType.tweet);
    try {
      _searchedTweets = await _tweetApiService.getTweetsByHashtag(tag);
      _errorMessage = '';
    } catch (e) {
      _searchedTweets = [];
      _setError("Failed to fetch hashtag tweets");
      debugPrint("Hashtag search error: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Clear All Search ===
  void clearSearch() {
    _searchedUsers = [];
    _searchedTweets = [];
    _errorMessage = '';
    _currentSearchType = SearchType.none;
    notifyListeners();
  }
}
