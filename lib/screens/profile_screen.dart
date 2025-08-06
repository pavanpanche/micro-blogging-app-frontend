// ✅ FINAL UPDATED PROFILE SCREEN WITH FOLLOW/UNFOLLOW INTEGRATION

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subtxt_blog/provider/like_provider.dart';
import 'package:subtxt_blog/provider/profile_provider.dart';
import 'package:subtxt_blog/screens/edit_profile_screen.dart';
import 'package:subtxt_blog/screens/tweet_details_screen.dart';
import 'package:subtxt_blog/widgets/user_card.dart';
import 'package:subtxt_blog/widgets/tweet_card.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;

  const ProfileScreen({super.key, this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile(username: widget.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final likeProvider = context.watch<LikeProvider>();

    final isCurrentUser = profileProvider.isCurrentUser;
    final username = profileProvider.username;
    final isFollowing = profileProvider.isFollowing;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCurrentUser
              ? 'My Profile'
              : username != null
              ? '@$username'
              : 'Profile',
        ),
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: "Edit Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
            ),
        ],
      ),
      body: profileProvider.isLoading || profileProvider.username == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () =>
                  profileProvider.loadProfile(username: widget.username),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        UserCard(
                          username: profileProvider.username!,
                          followerCount: profileProvider.followers.length,
                          followingCount: profileProvider.following.length,
                          onFollowersTap: () => _showUserListDialog(
                            context,
                            'Followers',
                            profileProvider.followers,
                          ),
                          onFollowingTap: () => _showUserListDialog(
                            context,
                            'Following',
                            profileProvider.following,
                          ),
                          onTweetsTap: () {},
                        ),
                        if (!isCurrentUser)
                          Positioned(
                            top: 16,
                            right: 20,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (isFollowing) {
                                  await profileProvider.unfollowUser(
                                    profileProvider.username!,
                                  );
                                } else {
                                  await profileProvider.followUser(
                                    profileProvider.username!,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFollowing
                                    ? Colors.grey[300]
                                    : Colors.blue,
                                foregroundColor: isFollowing
                                    ? Colors.black
                                    : Colors.white,
                              ),
                              child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                            ),
                          ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        "Tweets",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (profileProvider.userTweets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text("No tweets to display."),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: profileProvider.userTweets.length,
                        itemBuilder: (context, index) {
                          final tweet = profileProvider.userTweets[index];
                          final isOwner =
                              tweet.userId == profileProvider.loggedInUserId;

                          return TweetCard(
                            tweet: tweet,
                            currentUserId: profileProvider.loggedInUserId ?? 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      TweetDetailScreen(tweetId: tweet.id),
                                ),
                              );
                            },
                            onLikePressed: () async {
                              final response = await likeProvider.toggleLike(
                                tweet.id,
                              );

                              if (response != null) {
                                final updatedTweet = tweet.copyWith(
                                  isLiked: response.likedByCurrentUser,
                                  likeCount: response.totalLikes,
                                );

                                profileProvider.updateTweetInList(
                                  index,
                                  updatedTweet,
                                );
                              }
                            },
                            onDelete: isOwner
                                ? () async {
                                    await profileProvider.deleteTweet(tweet.id);
                                    if (!mounted) return;
                                    await profileProvider.loadProfile(
                                      username: profileProvider.username,
                                    );
                                  }
                                : null,
                            onEdit: isOwner ? () {} : null,
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showUserListDialog(
    BuildContext context,
    String title,
    List<String> users,
  ) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (ctx, i) {
                  final username = users[i];

                  return FutureBuilder<bool>(
                    future: provider.isFollowingUser(username),
                    builder: (context, snapshot) {
                      final isFollowing = snapshot.data ?? false;

                      return ListTile(
                        title: Text(username),
                        trailing: username != provider.loggedInUsername
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (isFollowing) {
                                    await provider.unfollowUser(username);
                                  } else {
                                    await provider.followUser(username);
                                  }

                                  if (!mounted) return;
                                  await provider.loadProfile(
                                    username: provider.username,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFollowing
                                      ? Colors.grey[300]
                                      : Colors.blue,
                                  foregroundColor: isFollowing
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                child: Text(
                                  isFollowing ? 'Unfollow' : 'Follow',
                                ),
                              )
                            : null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
