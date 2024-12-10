import 'package:flutter/material.dart';
import 'package:client/common/theme/palette.dart';

class AppTheme {
  static _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );

  static final darkModeTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Palette.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(Palette.borderColor),
      focusedBorder: _border(Palette.gradient2),
      errorBorder: _border(Palette.borderColor),
      focusedErrorBorder: _border(Palette.gradient2),
    ),
  );
}
