// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

// References:
// - https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/src/data/dates
// - https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/date_time_patterns.dart
// - https://github.com/dart-lang/i18n/blob/main/pkgs/intl/lib/date_symbol_data_local.dart
// - https://github.com/flutter/flutter/blob/master/packages/flutter_localizations/lib/src/l10n/generated_date_localizations.dart
// - https://github.com/unicode-org/cldr-json/blob/main/cldr-json/cldr-dates-full/main/en-IN/ca-generic.json
enum DateFormatPattern {
  @JsonValue('yMd')
  yMd(pattern: 'yMd'),
  @JsonValue('dd/MM/yyyy')
  ddMMyyyySlash(pattern: 'dd/MM/yyyy'),
  @JsonValue('dd-MM-yyyy')
  ddMMyyyyHyphen(pattern: 'dd-MM-yyyy'),
  @JsonValue('MM/dd/yyyy')
  MMddyyyySlash(pattern: 'MM/dd/yyyy'),
  @JsonValue('MM-dd-yyyy')
  MMddyyyyHyphen(pattern: 'MM-dd-yyyy'),
  @JsonValue('yyyy/MM/dd')
  yyyyMMddSlash(pattern: 'yyyy/MM/dd'),
  @JsonValue('yyyy-MM-dd')
  yyyyMMddHyphen(pattern: 'yyyy-MM-dd'),
  @JsonValue('yyyy-MMM-dd')
  yyyyMMMddHyphen(pattern: 'yyyy-MMM-dd');

  const DateFormatPattern({
    required this.pattern,
  });

  final String pattern;
}
