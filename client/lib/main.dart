import 'package:flutter/material.dart';
import 'package:client/common/theme/theme.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vibelle',
      theme: AppTheme.darkModeTheme,
      home: const SignupScreen(),
    );
  }
}
