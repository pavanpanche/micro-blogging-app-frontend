import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal() {
    dio.interceptors.add(authInterceptor());
  }

  final Dio dio = Dio(BaseOptions(baseUrl: 'http://localhost:8080/api/auth'));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Interceptor authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 &&
            !error.requestOptions.extra.containsKey("retry")) {
          try {
            final newToken = await refreshAccessToken();
            if (newToken != null) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $newToken';
              opts.extra['retry'] = true;
              final retryResponse = await dio.fetch(opts);
              return handler.resolve(retryResponse);
            }
          } catch (_) {
            await logout();
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Session expired. Please login again.',
                type: DioExceptionType.cancel,
              ),
            );
          }
        }
        handler.next(error);
      },
    );
  }

  Future<void> register(String username, String email, String password) async {
    await dio.post(
      '/register',
      data: {'username': username, 'email': email, 'password': password},
    );
  }

  Future<void> login(String email, String password) async {
    final res = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );

    await _storage.write(key: 'accessToken', value: res.data['accessToken']);
    await _storage.write(key: 'refreshToken', value: res.data['refreshToken']);
    await _storage.write(key: 'username', value: res.data['username']);
  }

  Future<void> logout() async => await _storage.deleteAll();

  Future<String?> getUsername() async => _storage.read(key: 'username');
  Future<String?> getAccessToken() async => _storage.read(key: 'accessToken');
  Future<String?> getRefreshToken() async => _storage.read(key: 'refreshToken');

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final res = await dio.post(
        '/refresh',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );
      final newToken = res.data['accessToken'];
      if (newToken != null) {
        await _storage.write(key: 'accessToken', value: newToken);
        return newToken;
      }
    } catch (_) {
      await logout();
    }
    return null;
  }
}
