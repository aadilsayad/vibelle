// ignore_for_file: avoid_public_notifier_properties
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/main/model/track.dart';
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

  @override
  Track? build() {
    audioPlayer = AudioPlayer();
    playlist = ConcatenatingAudioSource(children: []);

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
      }
    });

    return null;
  }

  void setPlaylist(List<Track> tracks) async {
    if (isShuffled) {
      toggleShuffle();
    }
    if (loopMode != LoopMode.off) {
      loopMode = LoopMode.off;
      audioPlayer?.setLoopMode(LoopMode.off);
    }

    trackList = tracks;
    final audioSources = await Future.wait(
      tracks.map((track) async {
        final trackStreamUrl = await ref
            .watch(mainViewModelProvider.notifier)
            .loadStreamUrl(track.id);
        return AudioSource.uri(Uri.parse(trackStreamUrl));
      }),
    );

    playlist = ConcatenatingAudioSource(children: audioSources);
    await audioPlayer!.setAudioSource(playlist!);
    state = state?.copyWith(primary_color: state?.primary_color);
  }

  void playTrack(Track track) async {
    if (isShuffled) {
      toggleShuffle();
    }
    if (loopMode != LoopMode.off) {
      loopMode = LoopMode.off;
      audioPlayer?.setLoopMode(LoopMode.off);
    }

    if (trackList.isEmpty || !trackList.contains(track)) {
      // Single track playback (old behavior)
      await audioPlayer?.stop();
      final trackStreamUrl = await ref
          .watch(mainViewModelProvider.notifier)
          .loadStreamUrl(track.id);

      playlist = ConcatenatingAudioSource(
        children: [AudioSource.uri(Uri.parse(trackStreamUrl))],
      );
      trackList = [track];

      await audioPlayer!.setAudioSource(playlist!);
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
    isPlaying = !isPlaying;
    state = state?.copyWith(primary_color: state?.primary_color);
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
