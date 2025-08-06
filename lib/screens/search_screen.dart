// lib/screens/search_view.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/provider/search_provider.dart';
import 'package:subtxt_blog/screens/profile_screen.dart';

import 'package:subtxt_blog/services/profile_api_service.dart';
import 'package:subtxt_blog/services/tweet_api_serivce.dart';
import 'package:subtxt_blog/services/user_api_service.dart';
// import your provider

class SearchScreen extends StatefulWidget {
  final TweetApiService tweetApiService;
  final UserApiService userApiService;
  final ProfileApiService profileApiService;

  const SearchScreen({
    super.key,
    required this.tweetApiService,
    required this.userApiService,
    required this.profileApiService,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchType = 'tweet'; // or 'user'

  void _onSearchChanged(String value, SearchProvider provider) {
    final query = value.trim();
    if (query.isEmpty) {
      provider.clearSearch();
    } else {
      if (_searchType == 'tweet') {
        provider.searchTweetsByKeyword(query);
      } else {
        provider.searchUsers(query);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(
        userApiService: widget.userApiService,
        tweetApiService: widget.tweetApiService,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          actions: [
            Consumer<SearchProvider>(
              builder: (_, provider, __) => Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  top: 8,
                ), // Adjust values as needed
                child: DropdownButton<String>(
                  value: _searchType,
                  dropdownColor: Colors.black,
                  underline: const SizedBox(), // Removes default underline
                  iconEnabledColor: Colors.white, // Icon color
                  items: const [
                    DropdownMenuItem(
                      value: 'tweet',
                      child: Text(
                        'Tweets',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'user',
                      child: Text(
                        'Users',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _searchType = value;
                        _onSearchChanged(_controller.text, provider);
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
        body: Consumer<SearchProvider>(
          builder: (context, provider, _) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  onChanged: (val) => _onSearchChanged(val, provider),
                  decoration: const InputDecoration(
                    hintText: 'Search users or tweets...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (_) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (provider.errorMessage.isNotEmpty) {
                      return Center(child: Text(provider.errorMessage));
                    } else if (provider.currentSearchType == SearchType.none) {
                      return const Center(child: Text('No results found.'));
                    } else if (provider.currentSearchType == SearchType.user) {
                      return ListView.builder(
                        itemCount: provider.searchedUsers.length,
                        itemBuilder: (_, i) {
                          final UserSearch user = provider.searchedUsers[i];
                          return ListTile(
                            title: Text('@${user.username}'),
                            leading: const Icon(Icons.person),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProfileScreen(username: user.username),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: provider.searchedTweets.length,
                        itemBuilder: (_, i) {
                          final Tweet tweet = provider.searchedTweets[i];
                          return ListTile(
                            title: Text(tweet.content),
                            subtitle: Text('@${tweet.username}'),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
