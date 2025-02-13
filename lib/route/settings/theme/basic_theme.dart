import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../name_theme_extension.dart';

class BasicTheme {
  static const Color seedColor = ColorsExt.flutterBlue;

  static final ThemeData themeDataLight = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
    ),
    useMaterial3: true,
    extensions: const [
      NameThemeExtension(
        name: 'basicThemeLight',
        displayName: 'Basic Theme Light',
      ),
    ],
  );

  static final ThemeData themeDataDark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: const [
      NameThemeExtension(
        name: 'basicThemeDark',
        displayName: 'Basic Theme Dark',
      ),
    ],
  );
}
