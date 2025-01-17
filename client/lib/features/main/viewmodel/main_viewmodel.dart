import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/common/providers/current_user_notifier.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/model/playlist.dart';
import 'package:client/features/main/repositories/main_remote_repository.dart';
import 'package:client/features/main/repositories/main_local_repository.dart';
part 'main_viewmodel.g.dart';

@riverpod
Future<List<Track>> initGetTrendingTracks(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.accessToken;
  final response = await ref
      .watch(mainRemoteRepositoryProvider)
      .getTrendingTracks(token: token);

  final switchCase = switch (response) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return switchCase;
}

@riverpod
Future<List<Playlist>> initGetTrendingPlaylists(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.accessToken;
  final response = await ref
      .watch(mainRemoteRepositoryProvider)
      .getTrendingPlaylists(token: token);

  final switchCase = switch (response) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return switchCase;
}

@riverpod
class MainViewModel extends _$MainViewModel {
  late final MainRemoteRepository _mainRemoteRepository;
  late final MainLocalRepository _mainLocalRepository;

  @override
  AsyncValue? build() {
    _mainRemoteRepository = ref.read(mainRemoteRepositoryProvider);
    _mainLocalRepository = ref.read(mainLocalRepositoryProvider);
    return null;
  }

  Future<String> loadStreamUrl(String trackId) async {
    final token = ref.watch(currentUserNotifierProvider)!.accessToken;
    final response = await _mainRemoteRepository.getTrackStreamUrl(
        token: token, trackId: trackId);

    final switchCase = switch (response) {
      Left(value: final l) => throw l.message,
      Right(value: final r) => r,
    };

    return switchCase;
  }

  List<dynamic> getRecentlyPlayed() {
    return _mainLocalRepository.getRecentlyPlayed();
  }

  void recordTrackPlay(Track track, {Playlist? fromPlaylist}) {
    _mainLocalRepository.recordTrackPlay(track, fromPlaylist: fromPlaylist);
  }
}
