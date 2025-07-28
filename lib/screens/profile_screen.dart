// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/follow_bloc.dart';
import 'package:subtxt_blog/bloc/follow_event.dart';
import 'package:subtxt_blog/bloc/follow_state.dart';
import 'package:subtxt_blog/bloc/feed_bloc.dart';
import 'package:subtxt_blog/bloc/feed_event.dart';
import 'package:subtxt_blog/bloc/feed_state.dart';
import 'package:subtxt_blog/screens/follower_screen.dart';
import 'package:subtxt_blog/screens/following_screen.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:subtxt_blog/services/follow_api_service.dart';
import 'package:subtxt_blog/services/user_api_service.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final FeedApiService feedApiService;
  final UserApiService userApiService;
  final FollowApiService followApiService;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.feedApiService,
    required this.userApiService,
    required this.followApiService,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FollowBloc>().add(LoadFollowData(widget.username));
    context.read<FeedBloc>().add(FetchTweetsByUsername(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, followState) {
          return Column(
            children: [
              if (followState.loading) CircularProgressIndicator(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FollowersScreen(username: widget.username),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'Followers',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${followState.followers}'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FollowingScreen(username: widget.username),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'Following',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${followState.following}'),
                      ],
                    ),
                  ),
                ],
              ),

              ElevatedButton(
                onPressed: () {
                  context.read<FollowBloc>().add(
                    ToggleFollowUser(widget.username),
                  );
                },
                child: Text(followState.isFollowing ? 'Unfollow' : 'Follow'),
              ),
              const Divider(),

              Expanded(
                child: BlocBuilder<FeedBloc, FeedState>(
                  builder: (context, feedState) {
                    if (feedState is FeedLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (feedState is TweetsByUserLoaded) {
                      if (feedState.tweets.isEmpty) {
                        return const Center(child: Text("No tweets yet."));
                      }
                      return ListView.builder(
                        itemCount: feedState.tweets.length,
                        itemBuilder: (context, index) {
                          final tweet = feedState.tweets[index];
                          return ListTile(title: Text(tweet.content));
                        },
                      );
                    } else {
                      return const Center(child: Text("Something went wrong"));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
