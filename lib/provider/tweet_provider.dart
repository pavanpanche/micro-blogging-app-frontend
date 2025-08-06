import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/tweet_request.dart';
import 'package:subtxt_blog/services/tweet_api_serivce.dart';

class TweetProvider with ChangeNotifier {
  int _currentPage = 0;
  final int _pageSize = 10;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  late TweetApiService _tweetService;
  TweetApiService get tweetApiService => _tweetService;

  TweetProvider(TweetApiService tweetService) {
    _tweetService = tweetService;
  }

  void setService(TweetApiService service) {
    _tweetService = service;
  }

  List<Tweet> _tweets = [];
  Tweet? _selectedTweet;
  bool _isLoading = false;

  List<Tweet> get tweets => _tweets;
  Tweet? get selectedTweet => _selectedTweet;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // === Fetch Feed ===
  Future<void> fetchUserFeed({int page = 0, int size = 10}) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.fetchFeed(page: page, size: size);
      _currentPage = page;
      _hasMore = true;
    } catch (e) {
      debugPrint("Error fetching feed: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Fetch All Tweets ===
  Future<void> fetchAllTweets() async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.fetchAllTweets();
    } catch (e) {
      debugPrint("Error fetching all tweets: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Fetch Recent Tweets ===
  Future<void> fetchRecentTweets({int page = 0, int size = 10}) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.fetchRecentTweets(page: page, size: size);
      _currentPage = page;
      _hasMore = true;
    } catch (e) {
      debugPrint("Error fetching recent tweets: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Search Tweets ===
  Future<void> searchTweets(String query) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.searchTweets(query);
    } catch (e) {
      debugPrint("Error searching tweets: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Tweets by Username (paginated) ===
  Future<void> fetchTweetsByUsername(
    String username, {
    int page = 0,
    int size = 10,
  }) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.getTweetsByUsername(
        username,
        page: page,
        size: size,
      );
    } catch (e) {
      debugPrint("Error fetching user tweets (paginated): $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Tweets by Username (all) ===
  Future<void> fetchTweetsByUsernameAll(String username) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.getTweetsByUsernameAll(username);
    } catch (e) {
      debugPrint("Error fetching user tweets (all): $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Tweets by Hashtag ===
  Future<void> fetchTweetsByHashtag(String tag) async {
    _setLoading(true);
    try {
      _tweets = await _tweetService.getTweetsByHashtag(tag);
      _hasMore = false; // optional: if hashtag search is not paginated
    } catch (e) {
      debugPrint("Error fetching hashtag tweets: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Get Tweet by ID ===
  Future<Tweet> getTweetById(int id) async {
    _setLoading(true);
    try {
      final tweet = await _tweetService.getTweetById(id);
      _selectedTweet = tweet;
      return tweet;
    } catch (e) {
      debugPrint("Error getting tweet by ID: $e");
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  //  create tweeet in feed screen
  Future<void> createTweet(TweetRequest request) async {
    _setLoading(true);
    try {
      debugPrint("Creating tweet: ${request.content}");
      final tweet = await _tweetService.createTweet(request);
      _tweets.insert(0, tweet);
      debugPrint("Tweet created successfully: ${tweet.id}");
    } catch (e) {
      debugPrint("Error in createTweet: $e");
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Update Tweet ===
  Future<void> updateTweet(int id, TweetRequest request) async {
    _setLoading(true);
    try {
      final updatedTweet = await _tweetService.updateTweet(id, request);
      final index = _tweets.indexWhere((tweet) => tweet.id == id);
      if (index != -1) {
        _tweets[index] = updatedTweet;
      }
    } catch (e) {
      debugPrint("Error updating tweet: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Delete Tweet ===
  Future<void> deleteTweet(int id) async {
    _setLoading(true);
    try {
      await _tweetService.deleteTweet(id);
      _tweets.removeWhere((tweet) => tweet.id == id);
    } catch (e) {
      debugPrint("Error deleting tweet: $e");
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // === Fetch Next Feed Page (Pagination) ===
  Future<void> fetchNextFeedPage() async {
    if (_isLoading || !_hasMore) return;

    _setLoading(true);
    try {
      final nextPageTweets = await _tweetService.fetchFeed(
        page: _currentPage + 1,
        size: _pageSize,
      );
      if (nextPageTweets.isEmpty) {
        _hasMore = false;
      } else {
        _currentPage++;
        _tweets.addAll(nextPageTweets);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching next feed page: $e");
    } finally {
      _setLoading(false);
    }
  }

  // === Clear All ===
  void clear() {
    _tweets = [];
    _selectedTweet = null;
    _currentPage = 0;
    _hasMore = true;
    notifyListeners();
  }

  // === Update Tweet In List ===
  void updateTweetInList(int index, Tweet updatedTweet) {
    if (index >= 0 && index < _tweets.length) {
      _tweets[index] = updatedTweet;
      notifyListeners();
    }
  }
}
