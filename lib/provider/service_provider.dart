import 'package:subtxt_blog/services/auth_service.dart';
import 'package:subtxt_blog/services/like_api_service.dart';
import 'package:subtxt_blog/services/profile_api_service.dart';
import 'package:subtxt_blog/services/tweet_api_serivce.dart';
import 'package:subtxt_blog/services/user_api_service.dart';

class ServiceProvider {
  final AuthService authService = AuthService();

  late final ProfileApiService profileApiService;
  late final TweetApiService tweetApiService;
  late final LikeApiService likeApiService;
  late final UserApiService userApiService;

  ServiceProvider() {
    profileApiService = ProfileApiService(authService.dio);
    tweetApiService = TweetApiService(authService.dio);
    likeApiService = LikeApiService(authService.dio);
    userApiService = UserApiService(authService.dio);
  }
}
