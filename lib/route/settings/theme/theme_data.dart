// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:json_annotation/json_annotation.dart';

import '../name_theme_extension.dart';
import 'basic_theme.dart';
import 'custom_theme.dart';
import 'flex_theme.dart';
import 'space_theme.dart';
import 'stock_theme.dart';

extension ThemeDataExt on ThemeData {
  static Set<ThemeData?> themeDatas = {
    system,
    light,
    dark,
    SpaceTheme.themeData,
    StockTheme.stockThemeDataLight,
    StockTheme.stockThemeDataDark,
    BasicTheme.themeDataLight,
    BasicTheme.themeDataDark,
    CustomTheme.themeDataLight,
    CustomTheme.themeDataDark,
    FlexTheme.themeDataLight,
    FlexTheme.themeDataDark,
  };

  String? get name {
    return extension<NameThemeExtension>()?.name;
  }

  String? get displayName {
    return extension<NameThemeExtension>()?.displayName;
  }

  static String getDisplayName({
    required AppLocalizations l10n,
    required ThemeData? themeData,
  }) {
    if (themeData == system) {
      return l10n.system;
    } else if (themeData == light) {
      return l10n.light;
    } else if (themeData == dark) {
      return l10n.dark;
    } else if (themeData == SpaceTheme.themeData) {
      return l10n.space;
    } else if (themeData!.displayName != null) {
      return themeData.displayName!;
    }
    throw ArgumentError.value(themeData, 'themeData', 'Invalid argument');
  }

  static const ThemeData? system = null;

  static final ThemeData light = CustomTheme.themeDataLight.copyWith(
    extensions: [
      const NameThemeExtension(name: 'light'),
    ],
  );

  static final ThemeData dark = CustomTheme.themeDataDark.copyWith(
    extensions: [
      const NameThemeExtension(name: 'dark'),
    ],
  );
}

class ThemeDataJsonConverter implements JsonConverter<ThemeData?, String?> {
  const ThemeDataJsonConverter();

  @override
  ThemeData? fromJson(String? name) {
    if (name == null) {
      return null;
    }
    for (final ThemeData themeData in ThemeDataExt.themeDatas.nonNulls) {
      if (name == themeData.name) {
        return themeData;
      }
    }
    throw ArgumentError.value(name, 'name', 'Not serialized');
  }

  @override
  String? toJson(ThemeData? themeData) {
    if (themeData == null) {
      return null;
    }
    if (themeData.name != null) {
      return themeData.name;
    }
    throw ArgumentError.value(themeData, 'themeData', 'Not serialized');
  }
}
