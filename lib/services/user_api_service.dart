import 'package:dio/dio.dart';
import '../models/user_search.dart'; // You'll need to define this model based on your backend's UserSearch DTO

class UserApiService {
  final Dio _dio;
  UserApiService(this._dio);

  /// Search users by username
  Future<List<UserSearch>> searchUsers(String username) async {
    final response = await _dio.get(
      '/user/search',
      queryParameters: {'username': username},
    );

    return (response.data as List)
        .map((json) => UserSearch.fromJson(json))
        .toList();
  }
}
