import 'package:subtxt_blog/services/auth_service.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:subtxt_blog/services/like_api_service.dart';

class ServiceProvider {
  final AuthService authService = AuthService();
  late final FeedApiService feedApiService;
  late final LikeApiService likeApiService;

  ServiceProvider() {
    feedApiService = FeedApiService(authService);
    likeApiService = LikeApiService(authService);
  }
}
