import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:client/common/utils/utils.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/common/providers/current_track_notifier.dart';
import 'package:client/features/main/view/screens/music_player_screen.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackNotifierProvider);
    final currentTrackNotifier =
        ref.read(currentTrackNotifierProvider.notifier);
    final isPlaying = currentTrackNotifier.playing;
    if (currentTrack == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => const MusicPlayerScreen(),
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 68,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: hexToColor(currentTrack.primary_color),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'track_artwork',
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(currentTrack.artwork_url),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 8),
                              height: 24,
                              child: currentTrack.title.length > 25
                                  ? Marquee(
                                      text: currentTrack.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: hexToColor(
                                            currentTrack.secondary_color),
                                      ),
                                      key: ValueKey(currentTrack.id),
                                      startAfter: const Duration(seconds: 1),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      blankSpace: 40.0,
                                      velocity: 30.0,
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                    )
                                  : Text(
                                      currentTrack.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: hexToColor(
                                            currentTrack.secondary_color),
                                      ),
                                    ),
                            ),
                            Text(
                              currentTrack.artist,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                                color: hexToColor(currentTrack.secondary_color),
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/images/heart_unfilled.png',
                        color: hexToColor(currentTrack.secondary_color),
                        width: 30,
                        height: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: currentTrackNotifier.togglePlaybackState,
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 30,
                        color: hexToColor(currentTrack.secondary_color),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: currentTrackNotifier.audioPlayer?.positionStream,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox();
              }

              final position = snapshot.data;
              final duration = currentTrackNotifier.audioPlayer?.duration;
              double progressRatio = 0.0;

              if (position != null && duration != null) {
                progressRatio =
                    position.inMilliseconds / duration.inMilliseconds;
              }

              double playbackProgress =
                  progressRatio * (MediaQuery.of(context).size.width - 32);

              return Positioned(
                bottom: 0,
                left: 8,
                child: Container(
                  height: 2,
                  width: playbackProgress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Palette.whiteColor,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Palette.inactiveSeekColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
