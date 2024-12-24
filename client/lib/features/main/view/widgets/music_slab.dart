import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/utils/utils.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/common/providers/current_track_notifier.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackNotifierProvider);
    final currentTrackNotifier =
        ref.read(currentTrackNotifierProvider.notifier);
    if (currentTrack == null) {
      return const SizedBox();
    }
    return Stack(
      children: [
        Container(
          height: 66,
          width: MediaQuery.of(context).size.width - 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: hexToColor(currentTrack.secondary_color),
          ),
          padding: const EdgeInsets.all(9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(currentTrack.artwork_url),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentTrack.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        currentTrack.artist,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.ellipsis,
                          color: Palette.subtitleText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Image.asset(
                      'assets/images/heart_unfilled.png',
                      color: Palette.whiteColor,
                      width: 36,
                      height: 36,
                    ),
                  ),
                  IconButton(
                    onPressed: currentTrackNotifier.togglePlaybackState,
                    icon: Icon(
                      currentTrackNotifier.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 36,
                      color: Palette.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 8,
          child: Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: Palette.whiteColor,
            ),
          ),
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
    );
  }
}
