import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:client/common/theme/theme.dart';
import 'package:client/common/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/main/view/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await Hive.initFlutter();
  await Hive.openBox('track_history');
  await Hive.openBox('playlist_history');
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).setupSharedPreferences();
  await container.read(authViewModelProvider.notifier).loadUserData();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibelle',
      theme: AppTheme.darkModeTheme,
      home: currentUser == null ? const SignupScreen() : const MainScreen(),
    );
  }
}
