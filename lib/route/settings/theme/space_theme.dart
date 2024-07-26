import 'package:flutter/material.dart';

import '../name_theme_extension.dart';
import 'custom_theme.dart';

class SpaceTheme {
  // WIP
  static final ThemeData themeData = CustomTheme.themeDataDark.copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Colors.transparent,
      ),
    ),
    extensions: [
      const NameThemeExtension(name: 'space'),
    ],
  );
}
