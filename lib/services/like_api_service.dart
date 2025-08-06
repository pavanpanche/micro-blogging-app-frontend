import 'package:dio/dio.dart';
import '../models/like_response.dart'; // Make sure to define this model based on your LikeResponse DTO

class LikeApiService {
  final Dio _dio;
  LikeApiService(this._dio);

  /// Toggle like/unlike for a tweet
  Future<LikeResponse> toggleLike(int tweetId) async {
    final response = await _dio.post('/likes/toggle/$tweetId');
    return LikeResponse.fromJson(response.data);
  }

  /// Get total like count for a tweet
  Future<int> getLikeCount(int tweetId) async {
    final response = await _dio.get('/likes/count/$tweetId');
    return response.data as int;
  }

  /// Check if current user has liked a tweet
  Future<bool> isLiked(int tweetId) async {
    final response = await _dio.get('/likes/status/$tweetId');
    return response.data as bool;
  }
}
