import 'package:dio/dio.dart';
import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/services/auth_service.dart';

class UserApiService {
  final Dio _dio;

  UserApiService(AuthService authService)
    : _dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/users')) {
    _dio.interceptors.add(authService.authInterceptor());
  }

  Future<List<UserSearch>> searchUsers(String query) async {
    final response = await _dio.get('/search', queryParameters: {'q': query});

    return (response.data as List)
        .map((json) => UserSearch.fromJson(json))
        .toList();
  }
}
