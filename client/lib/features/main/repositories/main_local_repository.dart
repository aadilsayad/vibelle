import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/model/playlist.dart';
import 'package:client/features/main/model/track_history_item.dart';
import 'package:client/features/main/model/playlist_play_history.dart';
part 'main_local_repository.g.dart';

@riverpod
MainLocalRepository mainLocalRepository(Ref ref) {
  return MainLocalRepository();
}

class MainLocalRepository {
  final Box trackHistoryBox = Hive.box('track_history');
  final Box playlistHistoryBox = Hive.box('playlist_history');

  void recordTrackPlay(Track track, {Playlist? fromPlaylist}) {
    if (fromPlaylist != null) {
      // For playlist tracks, create a new history item with unique timestamp ID
      final historyItem = TrackHistoryItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        playedAt: DateTime.now(),
        track: track,
        playlistId: fromPlaylist.id,
      );

      trackHistoryBox.put(historyItem.id, historyItem.toMap());

      // Update playlist history
      _updatePlaylistHistory(fromPlaylist);
    } else {
      // For standalone tracks, update existing record or create new one
      final historyItem = TrackHistoryItem(
        id: track.id, // Use track ID for standalone plays
        playedAt: DateTime.now(),
        track: track,
        playlistId: null,
      );
      trackHistoryBox.put(track.id, historyItem.toMap());
    }
  }

  // Private method to update playlist history
  void _updatePlaylistHistory(Playlist playlist) {
    final playlistHistory = PlaylistPlayHistory(
      playlistId: playlist.id,
      lastPlayedAt: DateTime.now(),
      playlist: playlist,
    );

    final map = playlistHistory.toMap();

    playlistHistoryBox.put(playlist.id, map);
  }

  // Get recently played items for home screen (8 items)
  List<dynamic> getRecentlyPlayed({int limit = 8}) {
    // Get all standalone tracks (ones without a playlist ID)
    final trackHistory = trackHistoryBox.values
        .map((item) {
          final map = Map<String, dynamic>.from(item as Map);
          map['track'] = Map<String, dynamic>.from(map['track'] as Map);
          return TrackHistoryItem.fromMap(map);
        })
        .where((item) => item.playlistId == null)
        .toList();

    // Get all playlist history
    final playlistHistory = playlistHistoryBox.values.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      map['playlist'] = Map<String, dynamic>.from(map['playlist'] as Map);
      if (map['playlist']['tracks'] != null) {
        map['playlist']['tracks'] = (map['playlist']['tracks'] as List)
            .map((track) => Map<String, dynamic>.from(track as Map))
            .toList();
      }

      return PlaylistPlayHistory.fromMap(map);
    }).toList();

    // Combine and sort by played time
    final List<dynamic> combinedHistory = [
      ...trackHistory,
      ...playlistHistory,
    ];
    combinedHistory.sort((a, b) {
      final DateTime aTime = a is TrackHistoryItem
          ? a.playedAt
          : (a as PlaylistPlayHistory).lastPlayedAt;
      final DateTime bTime = b is TrackHistoryItem
          ? b.playedAt
          : (b as PlaylistPlayHistory).lastPlayedAt;
      return bTime.compareTo(aTime);
    });

    final results = combinedHistory.take(limit).toList();
    return results;
  }

  // Get full listening history grouped by playlists
  List<Map<String, dynamic>> getFullHistory() {
    final allTracks = trackHistoryBox.values.map((item) {
      final map = Map<String, dynamic>.from(item as Map);
      map['track'] = Map<String, dynamic>.from(map['track'] as Map);
      return TrackHistoryItem.fromMap(map);
    }).toList()
      ..sort((a, b) => b.playedAt.compareTo(a.playedAt));

    final Map<String?, List<TrackHistoryItem>> groupedTracks =
        groupBy(allTracks, (TrackHistoryItem item) => item.playlistId);

    final List<Map<String, dynamic>> history = [];

    if (groupedTracks[null] != null) {
      history.add({
        'type': 'standalone',
        'tracks': groupedTracks[null]!,
      });
    }

    groupedTracks.forEach((playlistId, tracks) {
      if (playlistId != null) {
        final playlistData = playlistHistoryBox.get(playlistId);
        if (playlistData != null) {
          final map = Map<String, dynamic>.from(playlistData as Map);
          map['playlist'] = Map<String, dynamic>.from(map['playlist'] as Map);
          if (map['playlist']['tracks'] != null) {
            map['playlist']['tracks'] = (map['playlist']['tracks'] as List)
                .map((track) => Map<String, dynamic>.from(track as Map))
                .toList();
          }
          final playlist = PlaylistPlayHistory.fromMap(map);
          history.add({
            'type': 'playlist',
            'playlist': playlist,
            'tracks': tracks,
          });
        }
      }
    });

    history.sort((a, b) {
      final aTime = (a['tracks'] as List<TrackHistoryItem>).first.playedAt;
      final bTime = (b['tracks'] as List<TrackHistoryItem>).first.playedAt;
      return bTime.compareTo(aTime);
    });

    return history;
  }
}
