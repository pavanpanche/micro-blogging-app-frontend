import 'package:dio/dio.dart';

class ProfileApiService {
  final Dio _dio;
  ProfileApiService(this._dio);

  /// Follow a user
  Future<String> followUser(String username) async {
    final response = await _dio.post('/follow/$username');
    return response.data;
  }

  /// Unfollow a user
  Future<String> unfollowUser(String username) async {
    final response = await _dio.delete('/follow/$username');
    return response.data;
  }

  /// Get followers of a user
  Future<List<String>> getFollowers(String username) async {
    final response = await _dio.get('/follow/followers/$username');
    return List<String>.from(response.data);
  }

  /// Get following list of a user
  Future<List<String>> getFollowing(String username) async {
    final response = await _dio.get('/follow/following/$username');
    return List<String>.from(response.data);
  }

  /// Get follower and following count
  Future<Map<String, int>> getFollowCounts(String username) async {
    final response = await _dio.get('/follow/count/$username');
    return Map<String, int>.from(response.data);
  }

  /// Check if logged-in user is following another user
  Future<bool> isFollowing(String username) async {
    final response = await _dio.get('/follow/is-following/$username');
    return response.data as bool;
  }
}
