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
  @override
  Track? build() {
    return null;
  }

  void updateTrackPlaybackState(Track track) async {
    await audioPlayer?.stop();

    audioPlayer = AudioPlayer();
    final trackStreamUrl =
        await ref.watch(mainViewModelProvider.notifier).loadStreamUrl(track.id);

    final audioSource = AudioSource.uri(
      Uri.parse(trackStreamUrl),
    );

    await audioPlayer!.setAudioSource(audioSource);

    audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        audioPlayer!.seek(Duration.zero);
        audioPlayer!.pause();
        isPlaying = false;
        state = state?.copyWith(primary_color: state?.primary_color);
      }
    });

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
}
