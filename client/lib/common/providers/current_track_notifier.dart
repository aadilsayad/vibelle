import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/viewmodel/main_viewmodel.dart';
part 'current_track_notifier.g.dart';

@riverpod
class CurrentTrackNotifier extends _$CurrentTrackNotifier {
  late AudioPlayer? audioPlayer;
  bool isPlaying = false;
  @override
  Track? build() {
    return null;
  }

  void updateTrackPlaybackState(Track track) async {
    audioPlayer = AudioPlayer();
    final trackStreamUrl =
        await ref.watch(mainViewModelProvider.notifier).loadStreamUrl(track.id);

    final audioSource = AudioSource.uri(
      Uri.parse(trackStreamUrl),
    );

    await audioPlayer!.setAudioSource(audioSource);
    audioPlayer!.stop();
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
}
