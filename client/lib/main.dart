import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/common/theme/theme.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:client/features/home/view/screens/home_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/common/providers/current_user_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: currentUser == null ? const SignupScreen() : const HomeScreen(),
    );
  }
}
