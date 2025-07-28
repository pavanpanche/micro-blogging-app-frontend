// following_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/follow_bloc.dart';
import 'package:subtxt_blog/bloc/follow_event.dart';
import 'package:subtxt_blog/bloc/follow_state.dart';

class FollowingScreen extends StatefulWidget {
  final String username;

  const FollowingScreen({super.key, required this.username});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FollowBloc>().add(LoadFollowing(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.username} is following')),
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text(state.error));
          }

          if (state.followingList.isEmpty) {
            return const Center(child: Text("Not following anyone"));
          }

          return ListView.builder(
            itemCount: state.followingList.length,
            itemBuilder: (context, index) {
              final user = state.followingList[index];
              return ListTile(title: Text(user));
            },
          );
        },
      ),
    );
  }
}
