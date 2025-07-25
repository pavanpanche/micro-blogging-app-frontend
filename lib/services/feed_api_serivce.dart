import 'package:dio/dio.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/tweet_request.dart';
import 'package:subtxt_blog/services/auth_service.dart';

class FeedApiService {
  final Dio _dio;

  FeedApiService(AuthService authService)
    : _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/tweets')) {
    _dio.interceptors.add(authService.authInterceptor());
  }

  Future<List<Tweet>> fetchFeed({int page = 0, int size = 10}) async {
    final response = await _dio.get(
      '/feed',
      queryParameters: {'page': page, 'size': size},
    );

    return (response.data['content'] as List)
        .map((json) => Tweet.fromJson(json))
        .toList();
  }

  Future<List<Tweet>> fetchAllTweets() async {
    final response = await _dio.get('/');
    return (response.data as List).map((json) => Tweet.fromJson(json)).toList();
  }

  Future<Tweet> createTweet(TweetRequest request) async {
    final response = await _dio.post('/', data: request.toJson());
    return Tweet.fromJson(response.data);
  }

  Future<Tweet> updateTweet(int id, TweetRequest request) async {
    final response = await _dio.put('/$id', data: request.toJson());
    return Tweet.fromJson(response.data);
  }

  Future<void> deleteTweet(int id) async {
    await _dio.delete('/$id');
  }

  Future<Tweet> getTweetById(int id) async {
    final response = await _dio.get('/$id');
    return Tweet.fromJson(response.data);
  }
}
