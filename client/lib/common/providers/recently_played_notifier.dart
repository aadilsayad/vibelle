import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/main/repositories/main_local_repository.dart';
part 'recently_played_notifier.g.dart';

@riverpod
class RecentlyPlayedNotifier extends _$RecentlyPlayedNotifier {
  @override
  List<dynamic> build() {
    ref.listen(
      mainLocalRepositoryProvider
          .select((repo) => repo.trackHistoryBox.values.length),
      (previous, next) => ref.invalidateSelf(),
    );

    ref.listen(
      mainLocalRepositoryProvider
          .select((repo) => repo.playlistHistoryBox.values.length),
      (previous, next) => ref.invalidateSelf(),
    );

    return ref.read(mainLocalRepositoryProvider).getRecentlyPlayed();
  }

  void refresh() {
    state = ref.read(mainLocalRepositoryProvider).getRecentlyPlayed();
  }
}
