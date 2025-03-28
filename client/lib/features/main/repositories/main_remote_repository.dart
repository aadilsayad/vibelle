import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/common/failures/app_failure.dart';
import 'package:client/common/constants/server_constants.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/model/playlist.dart';
part 'main_remote_repository.g.dart';

@riverpod
MainRemoteRepository mainRemoteRepository(Ref ref) {
  return MainRemoteRepository();
}

class MainRemoteRepository {
  Future<Either<AppFailure, List<Track>>> getTrendingTracks(
      {required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverURL}/music/tracks/trending'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      var responseBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        responseBodyMap = responseBodyMap as Map<String, dynamic>;
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }

      responseBodyMap = responseBodyMap as List;

      final List<Track> trendingTracks = [];
      for (final track in responseBodyMap) {
        trendingTracks.add(Track.fromMap(track));
      }
      return Right(trendingTracks);
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<AppFailure, Map<String, String>>> getTrackStreamUrl({
    required String token,
    required String trackId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ServerConstants.serverURL}/music/tracks/stream'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {'track_id': trackId},
        ),
      );
      final responseBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }

      return Right({
        'stream_url': responseBodyMap['stream_url'],
        'primary_color': responseBodyMap['primary_color'],
        'secondary_color': responseBodyMap['secondary_color']
      });
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<AppFailure, List<Playlist>>> getTrendingPlaylists(
      {required String token}) async {
    try {
      final response = await http.get(
        Uri.parse('${ServerConstants.serverURL}/music/playlists/trending'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      var responseBodyMap = jsonDecode(response.body);
      if (response.statusCode != 200) {
        responseBodyMap = responseBodyMap as Map<String, dynamic>;
        return Left(
          AppFailure(
            responseBodyMap['detail'],
          ),
        );
      }

      responseBodyMap = responseBodyMap as List;

      final List<Playlist> trendingPlaylists = [];
      for (final playlist in responseBodyMap) {
        trendingPlaylists.add(Playlist.fromMap(playlist));
      }
      return Right(trendingPlaylists);
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }
}
