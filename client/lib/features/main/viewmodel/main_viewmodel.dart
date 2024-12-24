// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency

import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/common/providers/current_user_notifier.dart';
import 'package:client/features/main/model/track.dart';
import 'package:client/features/main/repositories/main_repository.dart';
part 'main_viewmodel.g.dart';

@riverpod
Future<List<Track>> initGetTrendingTracks(Ref ref) async {
  final token = ref.watch(currentUserNotifierProvider)!.accessToken;
  final response =
      await ref.watch(mainRepositoryProvider).getTrendingTracks(token: token);

  final switchCase = switch (response) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };

  return switchCase;
}

@riverpod
class MainViewModel extends _$MainViewModel {
  late MainRepository _mainRepository;

  @override
  AsyncValue? build() {
    _mainRepository = ref.watch(mainRepositoryProvider);
    return null;
  }
}
