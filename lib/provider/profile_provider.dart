import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/services/auth_service.dart';
import '../models/follow_count.dart';
import '../services/profile_api_service.dart';
import '../services/tweet_api_serivce.dart';

// ... all your imports

class ProfileProvider with ChangeNotifier {
  final ProfileApiService _profileService;
  final TweetApiService _tweetService;
  final AuthService authService;

  ProfileProvider(this._profileService, this._tweetService, this.authService);

  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;

  List<String> _followers = [];
  List<String> get followers => _followers;

  List<String> _following = [];
  List<String> get following => _following;

  List<Tweet> _tweets = [];
  List<Tweet> get userTweets => _tweets;

  FollowCount _followCount = FollowCount(followers: 0, following: 0);
  FollowCount get followCount => _followCount;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _username;
  String? get username => _username;

  String? _loggedInUsername;
  String? get loggedInUsername => _loggedInUsername;

  int? _loggedInUserId;
  int? get loggedInUserId => _loggedInUserId;

  bool get isCurrentUser => _username != null && _username == _loggedInUsername;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadProfile({String? username}) async {
    _setLoading(true);
    try {
      _loggedInUsername = await authService.getUsername();
      _loggedInUserId = await authService.getUserId();

      final resolvedUsername = username ?? _loggedInUsername;

      if (resolvedUsername == null) {
        debugPrint("No username found in loadProfile");
        _setLoading(false);
        return;
      }

      _username = resolvedUsername;
      notifyListeners();

      await Future.wait([
        fetchFollowCounts(_username!),
        fetchFollowers(_username!),
        fetchFollowing(_username!),
        fetchTweetsByUsername(_username!),
        checkIfFollowing(_username!),
      ]);
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> followUser(String username) async {
    _setLoading(true);
    try {
      await _profileService.followUser(username);
      _isFollowing = true;
      await _refreshFollowData(username);
    } catch (e) {
      debugPrint("Error following user: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> unfollowUser(String username) async {
    _setLoading(true);
    try {
      await _profileService.unfollowUser(username);
      _isFollowing = false;
      await _refreshFollowData(username);
    } catch (e) {
      debugPrint("Error unfollowing user: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refreshFollowData(String username) async {
    await Future.wait([
      fetchFollowCounts(username),
      fetchFollowers(username),
      fetchFollowing(username),
      checkIfFollowing(username),
    ]);
    notifyListeners();
  }

  Future<void> fetchFollowers(String username) async {
    try {
      _followers = await _profileService.getFollowers(username);
    } catch (e) {
      debugPrint("Error fetching followers: $e");
    }
  }

  Future<void> fetchFollowing(String username) async {
    try {
      _following = await _profileService.getFollowing(username);
    } catch (e) {
      debugPrint("Error fetching following: $e");
    }
  }

  Future<void> fetchFollowCounts(String username) async {
    try {
      final countMap = await _profileService.getFollowCounts(username);
      _followCount = FollowCount(
        followers: countMap['followers'] ?? 0,
        following: countMap['following'] ?? 0,
      );
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching follow counts: $e");
    }
  }

  Future<bool> isFollowingUser(String username) async {
    try {
      return await _profileService.isFollowing(username);
    } catch (e) {
      debugPrint("Error checking follow status for $username: $e");
      return false;
    }
  }

  Future<void> checkIfFollowing(String username) async {
    try {
      _isFollowing = await _profileService.isFollowing(username);
      notifyListeners();
    } catch (e) {
      debugPrint("Error checking follow status: $e");
      _isFollowing = false;
    }
  }

  Future<void> fetchTweetsByUsername(
    String username, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      _tweets = await _tweetService.getTweetsByUsername(
        username,
        page: page,
        size: size,
      );
    } catch (e) {
      debugPrint("Error fetching user tweets: $e");
    }
  }

  Future<void> deleteTweet(int tweetId) async {
    try {
      await _tweetService.deleteTweet(tweetId);
      _tweets.removeWhere((t) => t.id == tweetId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting tweet: $e");
    }
  }

  bool isOwnerOfTweet(Tweet tweet) {
    return tweet.userId == _loggedInUserId;
  }

  void updateTweetInList(int index, Tweet updatedTweet) {
    if (index >= 0 && index < _tweets.length) {
      _tweets[index] = updatedTweet;
      notifyListeners();
    }
  }

  void clear() {
    _isFollowing = false;
    _followers = [];
    _following = [];
    _followCount = FollowCount(followers: 0, following: 0);
    _tweets = [];
    _username = null;
    _loggedInUserId = null;
    _loggedInUsername = null;
    notifyListeners();
  }
}
