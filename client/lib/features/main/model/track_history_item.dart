import 'package:client/features/main/model/track.dart';

class TrackHistoryItem {
  final String id;
  final DateTime playedAt;
  final Track track;
  final String? playlistId; // null if played standalone

  TrackHistoryItem({
    required this.id,
    required this.playedAt,
    required this.track,
    this.playlistId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playedAt': playedAt.millisecondsSinceEpoch,
      'track': track.toMap(),
      'playlistId': playlistId,
    };
  }

  factory TrackHistoryItem.fromMap(Map<String, dynamic> map) {
    return TrackHistoryItem(
      id: map['id'] as String,
      playedAt: DateTime.fromMillisecondsSinceEpoch(map['playedAt']),
      track: Track.fromMap(map['track']),
      playlistId: map['playlistId'],
    );
  }
}
