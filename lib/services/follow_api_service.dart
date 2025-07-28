import 'package:dio/dio.dart';
import 'package:subtxt_blog/models/follow_count.dart';
import 'package:subtxt_blog/services/auth_service.dart';

class FollowApiService {
  final Dio _dio;
  final AuthService _authService;

  FollowApiService(this._authService)
    : _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/follow')) {
    _dio.interceptors.add(_authService.authInterceptor());
  }

  /// Follow a user
  Future<String> followUser(String username) async {
    final response = await _dio.post('/$username');
    return response.data.toString();
  }

  /// Unfollow a user
  Future<String> unfollowUser(String username) async {
    final response = await _dio.delete('/$username');
    return response.data.toString();
  }

  /// Get list of followers
  Future<List<String>> getFollowers(String username) async {
    final response = await _dio.get('/followers/$username');
    if (response.statusCode == 200) {
      return List<String>.from(response.data);
    } else {
      throw Exception('Failed to fetch followers');
    }
  }

  /// Get list of following
  Future<List<String>> getFollowing(String username) async {
    final response = await _dio.get('/following/$username');
    if (response.statusCode == 200) {
      return List<String>.from(response.data);
    } else {
      throw Exception('Failed to fetch following list');
    }
  }

  /// Get follower & following counts
  Future<FollowCount> getFollowCounts(String username) async {
    final response = await _dio.get('/count/$username');
    if (response.statusCode == 200) {
      return FollowCount.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch follow counts');
    }
  }

  /// Check if authenticated user is following [username]
  Future<bool> isFollowing(String username) async {
    final response = await _dio.get('/is-following/$username');
    if (response.statusCode == 200) {
      return response.data as bool;
    } else {
      throw Exception('Failed to check follow status');
    }
  }
}
