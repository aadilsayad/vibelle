import 'package:client/common/providers/current_track_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/theme/palette.dart';
import 'package:client/features/main/model/playlist.dart';
import 'package:client/features/main/view/widgets/fab_persistent_header_delegate.dart';

class PlaylistScreen extends ConsumerWidget {
  final Playlist playlist;
  const PlaylistScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Scaffold(
        backgroundColor: Palette.transparentColor,
        appBar: AppBar(
          backgroundColor: Palette.transparentColor,
        ),
        body: CustomScrollView(
          slivers: [
            // Playlist artwork and details
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Playlist artwork container
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 70),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(playlist.artwork_url),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),

                  // Playlist details
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.title,
                          style: const TextStyle(
                            color: Palette.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'A playlist by artist',
                          style: TextStyle(
                            color: Palette.subtitleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          playlist.artist,
                          style: const TextStyle(
                            color: Palette.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          '1h 54m',
                          style: TextStyle(
                            color: Palette.subtitleText,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                        // Row with heart and menu icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/heart_unfilled.png',
                                color: Palette.whiteColor,
                                width: 35,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_vert,
                                size: 35,
                                color: Palette.whiteColor,
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

            // Persistent Play Button FAB
            SliverPersistentHeader(
              pinned: true,
              delegate: FABPersistentHeaderDelegate(
                child: Center(
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_circle_filled,
                      size: 60,
                      color: Palette.whiteColor,
                    ),
                  ),
                ),
              ),
            ),

            // Tracks list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  final tracks = playlist.tracks;
                  return ListTile(
                    title: Text(tracks[index].title),
                    onTap: () async {},
                  );
                },
                childCount: playlist.tracks.length,
              ),
            ),
          ],
        ),

        //           const SizedBox(height: 10),
        //           SingleChildScrollView(
        //             child: SizedBox(
        //               height: 300,
        //               child: ListView.builder(
        //                 itemCount: playlist.tracks.length,
        //                 itemBuilder: (ctx, index) {
        //                   final tracks = playlist.tracks;
        //                   return ListTile(
        //                     title: Text(tracks[index].title),
        //                     onTap: () async {},
        //                   );
        //                 },
        //               ),
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
