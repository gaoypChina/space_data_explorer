// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../name_theme_extension.dart';
import 'basic_theme.dart';

class FlexTheme {
  static const Color _seedColor = BasicTheme.seedColor;

  static final ThemeData themeDataLight = FlexThemeData.light(
    colors: FlexSchemeColor.from(
      primary: _seedColor,
      secondary: _seedColor,
    ),
    useMaterial3: true,
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: const FlexTones.light().copyWith(
      primaryTone: 50,
      secondaryContainerTone: 84,
      backgroundTone: 98,
      surfaceTone: 98,
      // TODO(hrishikesh-kadam): Change this to surfaceContainer once it is
      // available in flex_color_scheme-8.x.x
      surfaceVariantTone: 94,
    ),
    // subThemesData: const FlexSubThemesData(
    //   // appBarBackgroundSchemeColor: SchemeColor.inversePrimary,
    // ),
    extensions: [
      const NameThemeExtension(
        name: 'flexThemeLight',
        displayName: 'Flex Theme Light',
      ),
    ],
  );

  static final ThemeData themeDataDark = FlexThemeData.dark(
    colors: FlexSchemeColor.from(
      primary: _seedColor,
      secondary: _seedColor,
    ),
    useMaterial3: true,
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: const FlexTones.dark().copyWith(
      primaryTone: 70,
      backgroundTone: 16,
      surfaceTone: 16,
      // TODO(hrishikesh-kadam): Change this to surfaceContainer once it is
      // available in flex_color_scheme-8.x.x
      surfaceVariantTone: 22,
    ),
    // subThemesData: const FlexSubThemesData(
    //   // appBarBackgroundSchemeColor: SchemeColor.inversePrimary,
    // ),
    extensions: [
      const NameThemeExtension(
        name: 'flexThemeDark',
        displayName: 'Flex Theme Dark',
      ),
    ],
  );
}
