import 'dart:async';
import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/screens/profile_screen.dart';
import 'package:subtxt_blog/screens/tweet_search_screen.dart';
import 'package:subtxt_blog/services/feed_api_serivce.dart';
import 'package:subtxt_blog/services/follow_api_service.dart';
import 'package:subtxt_blog/services/user_api_service.dart';
import 'package:subtxt_blog/widgets/user_card.dart';

class SearchScreen extends StatefulWidget {
  final FeedApiService feedApiService;
  final UserApiService userApiService;
  final FollowApiService followApiService;

  const SearchScreen({
    super.key,
    required this.feedApiService,
    required this.userApiService,
    required this.followApiService,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final List<String> _searchHistory = [];

  List<UserSearch> _userSuggestions = [];
  List<Tweet> _tweetResults = [];

  Timer? _debounce;
  bool _loading = false;

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (value.trim().isNotEmpty) {
        setState(() => _loading = true);
        try {
          final users = await widget.userApiService.searchUsers(value);
          final tweets = await widget.feedApiService.searchTweets(value);

          if (!mounted) return;
          setState(() {
            _userSuggestions = users;
            _tweetResults = tweets;
          });
        } catch (e) {
          debugPrint('Search error: $e');
        } finally {
          if (mounted) setState(() => _loading = false);
        }
      } else {
        if (mounted) {
          setState(() {
            _userSuggestions.clear();
            _tweetResults.clear();
          });
        }
      }
    });
  }

  void _onSearchSubmitted(String value) {
    if (value.trim().isEmpty) return;

    if (!_searchHistory.contains(value)) {
      setState(() => _searchHistory.insert(0, value));
    }
    _focusNode.unfocus();
    _onSearchChanged(value);
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _userSuggestions.clear();
      _tweetResults.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: 'Search users, tweets, or hashtags...',
            border: InputBorder.none,
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  )
                : null,
          ),
          textInputAction: TextInputAction.search,
          onChanged: _onSearchChanged,
          onSubmitted: _onSearchSubmitted,
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_searchHistory.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Searches',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _searchHistory.map((item) {
                          return ActionChip(
                            label: Text(item),
                            onPressed: () {
                              _controller.text = item;
                              _onSearchChanged(item);
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                if (_userSuggestions.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Users',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ..._userSuggestions.map(
                        (user) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                  username: user.username,
                                  feedApiService: widget.feedApiService,
                                  userApiService: widget.userApiService,
                                  followApiService: widget.followApiService,
                                ),
                              ),
                            );
                          },
                          child: UserCard(
                            username: user.username,
                            followerCount: user.followerCount,
                            followingCount: user.followingCount,
                            onFollowersTap: () {
                              Navigator.pushNamed(
                                context,
                                '/followers',
                                arguments: user.username,
                              );
                            },
                            onFollowingTap: () {
                              Navigator.pushNamed(
                                context,
                                '/following',
                                arguments: user.username,
                              );
                            },
                            onTweetsTap: () {
                              Navigator.pushNamed(
                                context,
                                '/userTweets',
                                arguments: user.username,
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                if (_tweetResults.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tweets',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ..._tweetResults.map(
                        (tweet) => ListTile(
                          title: Text(tweet.content),
                          subtitle: Text('@${tweet.username}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TweetResultsScreen(keyword: tweet.content),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                if (_userSuggestions.isEmpty &&
                    _tweetResults.isEmpty &&
                    _controller.text.isNotEmpty)
                  const Center(child: Text('No results found')),
              ],
            ),
    );
  }
}
