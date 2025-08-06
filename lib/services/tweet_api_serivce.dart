import 'package:dio/dio.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/tweet_request.dart';

class TweetApiService {
  final Dio _dio;
  TweetApiService(this._dio);

  Future<List<Tweet>> fetchFeed({int page = 0, int size = 10}) async {
    final response = await _dio.get(
      '/tweets/feed',
      queryParameters: {'page': page, 'size': size},
    );
    return (response.data['content'] as List)
        .map((json) => Tweet.fromJson(json))
        .toList();
  }

  Future<List<Tweet>> fetchAllTweets() async {
    final response = await _dio.get('/tweets/all');
    return (response.data as List).map((json) => Tweet.fromJson(json)).toList();
  }

  Future<Tweet> createTweet(TweetRequest request) async {
    final response = await _dio.post('/tweets', data: request.toJson());
    return Tweet.fromJson(response.data);
  }

  Future<Tweet> updateTweet(int id, TweetRequest request) async {
    final response = await _dio.put('/tweets/$id', data: request.toJson());
    return Tweet.fromJson(response.data);
  }

  Future<void> deleteTweet(int id) async {
    await _dio.delete('/tweets/$id');
  }

  Future<Tweet> getTweetById(int id) async {
    final response = await _dio.get('/tweets/$id');
    return Tweet.fromJson(response.data);
  }

  Future<List<Tweet>> fetchRecentTweets({int page = 0, int size = 10}) async {
    final response = await _dio.get(
      '/tweets/recent',
      queryParameters: {'page': page, 'size': size},
    );
    return (response.data['content'] as List)
        .map((json) => Tweet.fromJson(json))
        .toList();
  }

  Future<List<Tweet>> searchTweets(String query) async {
    final response = await _dio.get(
      '/tweets/search',
      queryParameters: {'query': query},
    );
    return (response.data as List).map((json) => Tweet.fromJson(json)).toList();
  }

  Future<List<Tweet>> getTweetsByUsername(
    String username, {
    int page = 0,
    int size = 10,
  }) async {
    final response = await _dio.get(
      '/tweets/user/$username/paginated',
      queryParameters: {'page': page, 'size': size},
    );
    return (response.data['content'] as List)
        .map((json) => Tweet.fromJson(json))
        .toList();
  }

  Future<List<Tweet>> getTweetsByUsernameAll(String username) async {
    final response = await _dio.get('/tweets/user/$username');
    return (response.data as List).map((json) => Tweet.fromJson(json)).toList();
  }

  Future<List<Tweet>> getTweetsByHashtag(String tag) async {
    final response = await _dio.get('/tweets/hashtag/$tag');
    return (response.data as List).map((json) => Tweet.fromJson(json)).toList();
  }
}
