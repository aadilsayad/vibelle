// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:client/features/main/model/track.dart';

class Playlist {
  final String id;
  final String title;
  final String artist;
  final String artwork_url;
  final List<Track> tracks;

  const Playlist({
    required this.id,
    required this.title,
    required this.artist,
    required this.artwork_url,
    required this.tracks,
  });

  Playlist copyWith({
    String? id,
    String? title,
    String? artist,
    String? artwork_url,
    List<Track>? tracks,
  }) {
    return Playlist(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artwork_url: artwork_url ?? this.artwork_url,
      tracks: tracks ?? this.tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artwork_url': artwork_url,
      'tracks': tracks.map((track) => track.toMap()).toList(),
    };
  }

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      artwork_url: map['artwork_url'] ?? '',
      tracks: List<dynamic>.from(map['tracks'] ?? [])
          .map((x) => Track.fromMap(x as Map<String, dynamic>))
          .toList(),
    );
  }
  String toJson() => jsonEncode(toMap());

  factory Playlist.fromJson(String source) =>
      Playlist.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Playlist{id: $id, title: $title, artist: $artist, artwork_url: $artwork_url, tracks: $tracks}';
  }
}
