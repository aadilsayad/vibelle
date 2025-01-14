import 'package:client/features/main/model/playlist.dart';

class PlaylistPlayHistory {
  final String playlistId;
  final DateTime lastPlayedAt;
  final Playlist playlist;

  PlaylistPlayHistory({
    required this.playlistId,
    required this.lastPlayedAt,
    required this.playlist,
  });

  Map<String, dynamic> toMap() {
    return {
      'playlistId': playlistId,
      'lastPlayedAt': lastPlayedAt.millisecondsSinceEpoch,
      'playlist': playlist.toMap(),
    };
  }

  factory PlaylistPlayHistory.fromMap(Map<String, dynamic> map) {
    return PlaylistPlayHistory(
      playlistId: map['playlistId'] as String,
      lastPlayedAt: DateTime.fromMillisecondsSinceEpoch(map['lastPlayedAt']),
      playlist: Playlist.fromMap(Map<String, dynamic>.from(map['playlist'])),
    );
  }
}
