// followers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/follow_bloc.dart';
import 'package:subtxt_blog/bloc/follow_event.dart';
import 'package:subtxt_blog/bloc/follow_state.dart';

class FollowersScreen extends StatefulWidget {
  final String username;

  const FollowersScreen({super.key, required this.username});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FollowBloc>().add(LoadFollowers(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.username}\'s Followers')),
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text(state.error));
          }

          if (state.followersList.isEmpty) {
            return const Center(child: Text("No followers"));
          }

          return ListView.builder(
            itemCount: state.followersList.length,
            itemBuilder: (context, index) {
              final user = state.followersList[index];
              return ListTile(title: Text(user));
            },
          );
        },
      ),
    );
  }
}
