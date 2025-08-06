import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/like_response.dart';
import 'package:subtxt_blog/services/like_api_service.dart';

class LikeProvider with ChangeNotifier {
  final LikeApiService _likeService;
  LikeProvider(this._likeService);

  final Map<int, bool> _likedStatus = {};
  final Map<int, int> _likeCounts = {};
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool isLiked(int tweetId) => _likedStatus[tweetId] ?? false;
  int getLikeCount(int tweetId) => _likeCounts[tweetId] ?? 0;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Toggle like/unlike a tweet
  Future<LikeResponse?> toggleLike(int tweetId) async {
    _setLoading(true);
    try {
      final response = await _likeService.toggleLike(tweetId);
      _likedStatus[tweetId] = response.likedByCurrentUser;
      _likeCounts[tweetId] = response.totalLikes;
      notifyListeners();
      return response;
    } catch (e) {
      debugPrint("Error toggling like for tweet $tweetId: $e");
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Load only the like count
  Future<void> loadLikeCount(int tweetId) async {
    try {
      final count = await _likeService.getLikeCount(tweetId);
      _likeCounts[tweetId] = count;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading like count for tweet $tweetId: $e");
    }
  }

  /// Load only the like status
  Future<void> loadLikeStatus(int tweetId) async {
    try {
      final liked = await _likeService.isLiked(tweetId);
      _likedStatus[tweetId] = liked;
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading like status for tweet $tweetId: $e");
    }
  }

  /// Initialize both like count and status
  Future<void> initializeLikeData(int tweetId) async {
    _setLoading(true);
    try {
      await Future.wait([loadLikeCount(tweetId), loadLikeStatus(tweetId)]);
    } catch (e) {
      debugPrint("Error initializing like data for tweet $tweetId: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Optional: clear all cached like data
  void clear() {
    _likedStatus.clear();
    _likeCounts.clear();
    notifyListeners();
  }
}
