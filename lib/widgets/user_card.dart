import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String username;
  final int followerCount;
  final int followingCount;

  final VoidCallback onFollowersTap;
  final VoidCallback onFollowingTap;
  final VoidCallback onTweetsTap;

  const UserCard({
    super.key,
    required this.username,
    required this.followerCount,
    required this.followingCount,
    required this.onFollowersTap,
    required this.onFollowingTap,
    required this.onTweetsTap,
  });

  Widget _buildStatBox(String label, int count, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: InkWell(
        onTap: onTweetsTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  username[0].toUpperCase(),
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "@$username",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatBox('Followers', followerCount, onFollowersTap),
                  const SizedBox(width: 8),
                  _buildStatBox('Following', followingCount, onFollowingTap),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
