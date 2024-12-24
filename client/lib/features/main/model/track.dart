// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

class Track {
  final String id;
  final String title;
  final String artist;
  final String artwork_url;
  final String song_url;
  final String primary_color;
  final String secondary_color;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.artwork_url,
    required this.song_url,
    required this.primary_color,
    required this.secondary_color,
  });

  Track copyWith({
    String? id,
    String? title,
    String? artist,
    String? artwork_url,
    String? song_url,
    String? primary_color,
    String? secondary_color,
  }) {
    return Track(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artwork_url: artwork_url ?? this.artwork_url,
      song_url: song_url ?? this.song_url,
      primary_color: primary_color ?? this.primary_color,
      secondary_color: secondary_color ?? this.secondary_color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'title': this.title,
      'artist': this.artist,
      'artwork_url': this.artwork_url,
      'song_url': this.song_url,
      'primary_color': this.primary_color,
      'secondary_color': this.secondary_color,
    };
  }

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      artist: map['artist'] ?? '',
      artwork_url: map['artwork_url'] ?? '',
      song_url: map['song_url'] ?? '',
      primary_color: map['primary_color'] ?? '',
      secondary_color: map['secondary_color'] ?? '',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Track.fromJson(String source) =>
      Track.fromMap(jsonDecode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Track{id: $id, title: $title, artist: $artist, artwork_url: $artwork_url, song_url: $song_url, primary_color: $primary_color, secondary_color: $secondary_color}';
  }
}
