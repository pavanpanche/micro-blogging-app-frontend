import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/search_bloc.dart';
import 'package:subtxt_blog/bloc/search_event.dart';
import 'package:subtxt_blog/bloc/search_state.dart';
import 'package:subtxt_blog/models/tweet_model.dart';
import 'package:subtxt_blog/models/user_search.dart';
import 'package:subtxt_blog/screens/profile_screen.dart';
import 'package:subtxt_blog/screens/tweet_search_screen.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  String _searchType = 'tweet'; // or 'user'

  void _onSearchChanged(String value) {
    final query = value.trim();
    if (query.isEmpty) {
      context.read<SearchBloc>().add(ClearSearchResults());
    } else {
      if (_searchType == 'tweet') {
        context.read<SearchBloc>().add(SearchTweetsByKeyword(query));
      } else {
        context.read<SearchBloc>().add(SearchUsers(query));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        actions: [
          DropdownButton<String>(
            value: _searchType,
            dropdownColor: Colors.black,
            items: const [
              DropdownMenuItem(
                value: 'tweet',
                child: Text('Tweets', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'user',
                child: Text('Users', style: TextStyle(color: Colors.white)),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _searchType = value;
                  _onSearchChanged(_controller.text);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search users or tweets...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  return const Center(child: Text('Start typing to search...'));
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchError) {
                  return Center(child: Text(state.message));
                } else if (state is UserSearchResult) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (_, i) {
                      final UserSearch user = state.users[i];
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
                } else if (state is TweetSearchResult) {
                  return ListView.builder(
                    itemCount: state.tweets.length,
                    itemBuilder: (_, i) {
                      final Tweet tweet = state.tweets[i];
                      return ListTile(
                        title: Text(tweet.content),
                        subtitle: Text('@${tweet.username}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TweetResultsScreen(
                                keyword: _controller.text.trim(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
