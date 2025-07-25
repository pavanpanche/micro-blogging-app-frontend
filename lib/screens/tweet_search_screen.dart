import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/search_bloc.dart';
import 'package:subtxt_blog/bloc/search_event.dart';
import 'package:subtxt_blog/bloc/search_state.dart';

class TweetResultsScreen extends StatelessWidget {
  final String keyword;

  const TweetResultsScreen({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    // Trigger search for the keyword when screen is opened
    context.read<SearchBloc>().add(SearchTweetsByKeyword(keyword));

    return Scaffold(
      appBar: AppBar(title: Text("Results for \"$keyword\"")),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TweetSearchResult) {
            if (state.tweets.isEmpty) {
              return const Center(child: Text("No tweets found."));
            }
            return ListView.builder(
              itemCount: state.tweets.length,
              itemBuilder: (context, index) {
                final tweet = state.tweets[index];
                return ListTile(
                  title: Text(tweet.content),
                  subtitle: Text('@${tweet.username}'),
                );
              },
            );
          } else if (state is SearchError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("Search a keyword"));
        },
      ),
    );
  }
}
