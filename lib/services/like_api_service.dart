import 'package:dio/dio.dart';
import 'package:subtxt_blog/services/auth_service.dart';


class LikeApiService {
  final Dio _dio;

  LikeApiService(AuthService authService)
      : _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/likes')) {
    _dio.interceptors.add(authService.authInterceptor());
  }

  Future<bool> toggleLike(int tweetId) async {
    final res = await _dio.post('/toggle/$tweetId');
    return res.data['liked'] as bool;
  }

  Future<int> getLikeCount(int tweetId) async {
    final res = await _dio.get('/count/$tweetId');
    return int.tryParse(res.data.toString()) ?? 0;
  }

  Future<bool> isLiked(int tweetId) async {
    final res = await _dio.get('/status/$tweetId');
    return res.data.toString() == 'true';
  }
}
