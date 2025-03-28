// ignore_for_file: avoid_public_notifier_properties
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/model/playlist.dart';
import 'package:client/features/main/viewmodel/main_viewmodel.dart';
part 'current_track_notifier.g.dart';

@riverpod
class CurrentTrackNotifier extends _$CurrentTrackNotifier {
  AudioPlayer? audioPlayer;
  bool isPlaying = false;
  bool isShuffled = false;
  LoopMode loopMode = LoopMode.off;
  List<Track> trackList = [];
  late ConcatenatingAudioSource? playlist;
  Playlist? currentPlaylist;

  @override
  Track? build() {
    audioPlayer = AudioPlayer();
    playlist = ConcatenatingAudioSource(children: []);

    audioPlayer!.playingStream.listen((playing) {
      isPlaying = playing;
      // Notify listeners of state change
      state = state?.copyWith(primary_color: state?.primary_color);
    });

    // Listen for track completion to handle auto-play
    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (!audioPlayer!.hasNext) {
          // If no next track, reset current track
          audioPlayer!.seek(Duration.zero);
          audioPlayer!.pause();
          isPlaying = false;
        }
        // Auto-play next track is handled automatically by JustAudio
        state = state?.copyWith(primary_color: state?.primary_color);
      }
    });

    // Listen for track changes to update state
    audioPlayer!.currentIndexStream.listen((index) {
      if (index != null && index < trackList.length) {
        state = trackList[index];
        if (currentPlaylist != null) {
          ref
              .read(mainViewModelProvider.notifier)
              .recordTrackPlay(trackList[index], fromPlaylist: currentPlaylist);
        }
      }
    });

    return null;
  }

  bool get playing => isPlaying;

  void setPlaylist(List<Track> tracks, {Playlist? selectedPlaylist}) async {
    currentPlaylist = selectedPlaylist;
    if (isShuffled) {
      toggleShuffle();
    }
    if (loopMode != LoopMode.off) {
      loopMode = LoopMode.off;
      audioPlayer?.setLoopMode(LoopMode.off);
    }
    state = state?.copyWith(primary_color: state?.primary_color);

    trackList = tracks;
    final audioSources = await Future.wait(
      tracks.map((track) async {
        final trackStreamData = await ref
            .watch(mainViewModelProvider.notifier)
            .loadStreamUrl(track.id);
        track = track.copyWith(
          primary_color: trackStreamData['primary_color'],
          secondary_color: trackStreamData['secondary_color'],
        );
        return AudioSource.uri(
          Uri.parse(trackStreamData['stream_url']!),
          tag: MediaItem(
            id: track.id,
            title: track.title,
            artist: track.artist,
            artUri: Uri.parse(track.artwork_url),
          ),
        );
      }),
    );

    playlist = ConcatenatingAudioSource(children: audioSources);
    await audioPlayer!.setAudioSource(playlist!);

    if (selectedPlaylist != null) {
      ref
          .read(mainViewModelProvider.notifier)
          .recordTrackPlay(tracks.first, fromPlaylist: selectedPlaylist);
    }

    state = state?.copyWith(primary_color: state?.primary_color);
  }

  void playTrack(Track track) async {
    if (trackList.isEmpty || !trackList.contains(track)) {
      // Single track playback
      currentPlaylist = null;
      if (isShuffled) {
        toggleShuffle();
      }
      if (loopMode != LoopMode.off) {
        loopMode = LoopMode.off;
        audioPlayer?.setLoopMode(LoopMode.off);
      }
      state = state?.copyWith(primary_color: state?.primary_color);

      await audioPlayer?.stop();
      final trackStreamData = await ref
          .watch(mainViewModelProvider.notifier)
          .loadStreamUrl(track.id);
      track = track.copyWith(
        primary_color: trackStreamData['primary_color'],
        secondary_color: trackStreamData['secondary_color'],
      );

      playlist = ConcatenatingAudioSource(
        children: [
          AudioSource.uri(
            Uri.parse(trackStreamData['stream_url']!),
            tag: MediaItem(
              id: track.id,
              title: track.title,
              artist: track.artist,
              artUri: Uri.parse(track.artwork_url),
            ),
          ),
        ],
      );
      trackList = [track];

      await audioPlayer!.setAudioSource(playlist!);
      ref.read(mainViewModelProvider.notifier).recordTrackPlay(track);
    } else {
      // Play track from existing playlist
      final trackIndex = trackList.indexOf(track);
      await audioPlayer!.seek(Duration.zero, index: trackIndex);
    }

    audioPlayer!.play();
    isPlaying = true;
    state = track;
  }

  void togglePlaybackState() {
    if (isPlaying) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
  }

  void seekToPosition(double position) {
    audioPlayer?.seek(
      Duration(
        milliseconds:
            (position * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }

  void skipToNext() {
    if (audioPlayer?.hasNext ?? false) {
      audioPlayer?.seekToNext();
    }
  }

  void skipToPrevious() {
    if (audioPlayer?.hasPrevious ?? false) {
      audioPlayer?.seekToPrevious();
    }
  }

  void toggleShuffle() {
    if (isShuffled) {
      audioPlayer?.setShuffleModeEnabled(false);
    } else {
      audioPlayer?.setShuffleModeEnabled(true);
    }
    isShuffled = !isShuffled;
    state = state?.copyWith(primary_color: state?.primary_color);
  }

  void toggleRepeat() {
    if (loopMode == LoopMode.off) {
      loopMode = LoopMode.all;
    } else if (loopMode == LoopMode.all) {
      loopMode = LoopMode.one;
    } else {
      loopMode = LoopMode.off;
    }
    audioPlayer?.setLoopMode(loopMode);
    state = state?.copyWith(primary_color: state?.primary_color);
  }
}
