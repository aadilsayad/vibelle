import 'package:client/common/theme/palette.dart';
import 'package:client/features/main/model/playlist_play_history.dart';
import 'package:client/features/main/model/track_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/widgets/widgets.dart';
import 'package:client/common/providers/current_track_notifier.dart';
import 'package:client/features/main/viewmodel/main_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlyPlayed =
        ref.watch(mainViewModelProvider.notifier).getRecentlyPlayed();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
              child: SizedBox(
                height: 280,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: recentlyPlayed.length,
                  itemBuilder: (ctx, index) {
                    final item = recentlyPlayed[index];
                    String title = '';
                    String artworkUrl = '';
                    VoidCallback? onTap;
                    if (item is TrackHistoryItem) {
                      title = item.track.title;
                      artworkUrl = item.track.artwork_url;
                      onTap = () {
                        ref
                            .read(currentTrackNotifierProvider.notifier)
                            .playTrack(item.track);
                      };
                    } else if (item is PlaylistPlayHistory) {
                      title = item.playlist.title;
                      artworkUrl = item.playlist.artwork_url;
                      onTap = () {
                        ref
                            .read(currentTrackNotifierProvider.notifier)
                            .setPlaylist(item.playlist.tracks,
                                selectedPlaylist: item.playlist);
                        ref
                            .read(currentTrackNotifierProvider.notifier)
                            .playTrack(item.playlist.tracks[0]);
                      };
                    }
                    return GestureDetector(
                      onTap: onTap,
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Palette.cardColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(artworkUrl),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  bottomLeft: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                title,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Trending Tracks',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ref.watch(initGetTrendingTracksProvider).when(
                  data: (tracks) {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentTrackNotifierProvider.notifier)
                                  .playTrack(track);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(track.artwork_url),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      track.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Trending Playlists',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ref.watch(initGetTrendingPlaylistsProvider).when(
                  data: (playlists) {
                    return SizedBox(
                      height: 210,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: playlists.length,
                        itemBuilder: (context, index) {
                          final playlist = playlists[index];
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(currentTrackNotifierProvider.notifier)
                                  .setPlaylist(playlist.tracks,
                                      selectedPlaylist: playlist);
                              ref
                                  .read(currentTrackNotifierProvider.notifier)
                                  .playTrack(playlist.tracks[0]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            NetworkImage(playlist.artwork_url),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      playlist.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Trending Artists',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
