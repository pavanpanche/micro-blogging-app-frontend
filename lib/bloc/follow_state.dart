import 'package:equatable/equatable.dart';

class FollowState extends Equatable {
  final int followers;
  final int following;
  final bool isFollowing;
  final List<String> followersList;
  final List<String> followingList;
  final bool loading;
  final String error;

  const FollowState({
    this.followers = 0,
    this.following = 0,
    this.isFollowing = false,
    this.followersList = const [],
    this.followingList = const [],
    this.loading = false,
    this.error = '',
  });

  FollowState copyWith({
    int? followers,
    int? following,
    bool? isFollowing,
    List<String>? followersList,
    List<String>? followingList,
    bool? loading,
    String? error,
  }) {
    return FollowState(
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isFollowing: isFollowing ?? this.isFollowing,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    followers,
    following,
    isFollowing,
    followersList,
    followingList,
    loading,
    error,
  ];
}
