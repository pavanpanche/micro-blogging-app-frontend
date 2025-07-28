import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtxt_blog/bloc/follow_event.dart';
import 'package:subtxt_blog/bloc/follow_state.dart';
import 'package:subtxt_blog/services/follow_api_service.dart';
import 'package:subtxt_blog/models/follow_count.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final FollowApiService followService;

  FollowBloc({required this.followService}) : super(const FollowState()) {
    on<LoadFollowData>(_onLoadFollowData);
    on<LoadFollowCounts>(_onLoadCounts);
    on<LoadFollowers>(_onLoadFollowers);
    on<LoadFollowing>(_onLoadFollowing);
    on<CheckFollowStatus>(_onCheckStatus);
    on<ToggleFollowUser>(_onToggleFollow);
  }

  Future<void> _onLoadCounts(
    LoadFollowCounts event,
    Emitter<FollowState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: ''));
    try {
      final FollowCount counts = await followService.getFollowCounts(
        event.username,
      );
      emit(
        state.copyWith(
          followers: counts.followers,
          following: counts.following,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onLoadFollowers(
    LoadFollowers event,
    Emitter<FollowState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: ''));
    try {
      final list = await followService.getFollowers(event.username);
      emit(state.copyWith(followersList: list, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onLoadFollowing(
    LoadFollowing event,
    Emitter<FollowState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: ''));
    try {
      final list = await followService.getFollowing(event.username);
      emit(state.copyWith(followingList: list, loading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }

  Future<void> _onCheckStatus(
    CheckFollowStatus event,
    Emitter<FollowState> emit,
  ) async {
    try {
      final status = await followService.isFollowing(event.username);
      emit(state.copyWith(isFollowing: status));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onToggleFollow(
    ToggleFollowUser event,
    Emitter<FollowState> emit,
  ) async {
    try {
      if (state.isFollowing) {
        await followService.unfollowUser(event.username);
        emit(
          state.copyWith(
            isFollowing: false,
            followers: state.followers > 0 ? state.followers - 1 : 0,
          ),
        );
      } else {
        await followService.followUser(event.username);
        emit(state.copyWith(isFollowing: true, followers: state.followers + 1));
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onLoadFollowData(
    LoadFollowData event,
    Emitter<FollowState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: ''));

    try {
      final counts = await followService.getFollowCounts(event.username);
      final isFollowing = await followService.isFollowing(event.username);

      emit(
        state.copyWith(
          followers: counts.followers,
          following: counts.following,
          isFollowing: isFollowing,
          loading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
