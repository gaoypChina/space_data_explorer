import 'package:flutter/material.dart';

import '../name_theme_extension.dart';

class StockTheme {
  static const Color _seedColor = Colors.deepPurple;

  static final ThemeData stockThemeDataLight = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
    ),
    useMaterial3: true,
    extensions: const [
      NameThemeExtension(
        name: 'stockThemeDataLight',
        displayName: 'Stock ThemeData Light',
      ),
    ],
  );

  static final ThemeData stockThemeDataDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: const [
      NameThemeExtension(
        name: 'stockThemeDataDark',
        displayName: 'Stock ThemeData Dark',
      ),
    ],
  );
}
