import 'package:flutter/material.dart';
import 'package:client/common/theme/theme.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.darkModeTheme,
      home: const SignupScreen(),
    );
  }
}
