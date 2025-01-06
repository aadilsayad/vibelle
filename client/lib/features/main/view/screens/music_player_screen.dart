import 'package:client/features/main/view/widgets/custom_rounded_rect_slider_track_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:client/common/utils/utils.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/common/providers/current_track_notifier.dart';

class MusicPlayerScreen extends ConsumerWidget {
  const MusicPlayerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrack = ref.watch(currentTrackNotifierProvider);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            hexToColor(currentTrack!.secondary_color),
            const Color(0xff121212),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Scaffold(
        backgroundColor: Palette.transparentColor,
        appBar: AppBar(
          backgroundColor: Palette.transparentColor,
          leading: Transform.translate(
            offset: const Offset(-10, 0),
            child: InkWell(
              highlightColor: Palette.transparentColor,
              splashColor: Palette.transparentColor,
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Hero(
                  tag: 'track_artwork',
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(currentTrack.artwork_url),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(right: 16),
                              height: 32,
                              child: currentTrack.title.length > 25
                                  ? Marquee(
                                      text: currentTrack.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      key: ValueKey(currentTrack.id),
                                      startAfter: const Duration(seconds: 1),
                                      scrollAxis: Axis.horizontal,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      blankSpace: 50.0,
                                      velocity: 30.0,
                                      pauseAfterRound:
                                          const Duration(seconds: 1),
                                    )
                                  : Text(
                                      currentTrack.title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                            Text(
                              currentTrack.artist,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                overflow: TextOverflow.ellipsis,
                                color: Palette.subtitleText,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/heart_unfilled.png',
                          color: Palette.whiteColor,
                          width: 40,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Palette.whiteColor,
                          inactiveTrackColor:
                              Palette.whiteColor.withOpacity(0.12),
                          thumbColor: Palette.whiteColor,
                          trackHeight: 4,
                          trackShape: CustomRoundedRectSliderTrackShape(),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: 0.5,
                          onChanged: (val) {},
                        ),
                      ),
                      const Row(
                        children: [
                          Text(
                            '0:05',
                            style: TextStyle(
                              color: Palette.subtitleText,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '1:00',
                            style: TextStyle(
                              color: Palette.subtitleText,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/shuffle_unfilled.png',
                          color: Palette.whiteColor,
                          width: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous,
                          size: 48,
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.play_circle_filled,
                          size: 80,
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_next,
                          size: 48,
                          color: Palette.whiteColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/repeat_unfilled.png',
                          color: Palette.whiteColor,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/lyrics_filled.png',
                          color: Palette.whiteColor,
                          width: 28,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/images/playlist.png',
                          color: Palette.whiteColor,
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
