import 'package:flutter/material.dart';
import 'package:subtxt_blog/models/user_search.dart';

class UserCard extends StatelessWidget {
  final UserSearch user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text('@${user.username}'),
      onTap: () {
        // Navigate to tweets by this user or open profile if needed
      },
    );
  }
}
