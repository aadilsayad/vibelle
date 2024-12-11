import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:client/features/auth/model/user.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/common/providers/current_user_notifier.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  late AuthLocalRepository _authLocalRepository;
  late CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<User>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> setupSharedPreferences() async {
    await _authLocalRepository.initSharedPreferencesInstance();
  }

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.signup(
      name: name,
      email: email,
      password: password,
    );

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final res = await _authRemoteRepository.login(
      email: email,
      password: password,
    );

    final _ = switch (res) {
      Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
      Right(value: final r) => _handleSuccessfulLogin(r),
    };
  }

  AsyncValue<User>? _handleSuccessfulLogin(User user) {
    _authLocalRepository.setToken(user.accessToken);
    _currentUserNotifier.setUser(user);
    return state = AsyncValue.data(user);
  }

  Future<User?> loadUserData() async {
    state = const AsyncValue.loading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final response = await _authRemoteRepository.fetchUserData(token);

      final switchCase = switch (response) {
        Left(value: final l) => state = AsyncValue.error(
            l.message,
            StackTrace.current,
          ),
        Right(value: final r) => _updateUserState(r),
      };

      return switchCase.value;
    }
    return null;
  }

  AsyncValue<User> _updateUserState(User user) {
    _currentUserNotifier.setUser(user);
    return state = AsyncValue.data(user);
  }
}
