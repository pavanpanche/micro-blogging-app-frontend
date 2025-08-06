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

  /// Adjusts opacity by percent (0.0–1.0) using withAlpha
  Color withAlphaPercent(Color color, double percent) {
    final clamped = percent.clamp(0.0, 1.0);
    return color.withAlpha((clamped * 255).round());
  }

  Widget _buildStatBox(
    BuildContext context,
    String label,
    int count,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: withAlphaPercent(accent, 0.08),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: withAlphaPercent(Colors.black, 0.05), // ✅ fixed
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: withAlphaPercent(
                    theme.colorScheme.onSurface,
                    0.6,
                  ), // ✅ fixed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: InkWell(
        onTap: onTweetsTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: withAlphaPercent(accent, 0.12),
                child: Text(
                  username[0].toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "@$username",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  _buildStatBox(
                    context,
                    'Followers',
                    followerCount,
                    onFollowersTap,
                  ),
                  const SizedBox(width: 12),
                  _buildStatBox(
                    context,
                    'Following',
                    followingCount,
                    onFollowingTap,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
