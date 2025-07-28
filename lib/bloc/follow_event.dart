import 'package:equatable/equatable.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

class LoadFollowCounts extends FollowEvent {
  final String username;

  const LoadFollowCounts(this.username);

  @override
  List<Object> get props => [username];
}

class LoadFollowers extends FollowEvent {
  final String username;

  const LoadFollowers(this.username);

  @override
  List<Object> get props => [username];
}

class LoadFollowing extends FollowEvent {
  final String username;

  const LoadFollowing(this.username);

  @override
  List<Object> get props => [username];
}

class CheckFollowStatus extends FollowEvent {
  final String username;

  const CheckFollowStatus(this.username);

  @override
  List<Object> get props => [username];
}

class ToggleFollowUser extends FollowEvent {
  final String username;

  const ToggleFollowUser(this.username);

  @override
  List<Object> get props => [username];
}

class LoadFollowData extends FollowEvent {
  final String username;

  const LoadFollowData(this.username);
}
