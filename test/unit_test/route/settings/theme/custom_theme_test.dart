import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'package:space_data_explorer/constants/colors.dart';
import 'package:space_data_explorer/route/settings/theme/custom_theme.dart';

void main() {
  group('$CustomTheme Unit Test', () {
    group('buildDynamicScheme()', () {
      test('secondaryColor', () {
        final DynamicScheme s1 = CustomTheme.buildDynamicScheme();
        final DynamicScheme s2 = CustomTheme.buildDynamicScheme(
          secondaryColor: ColorsExt.flutterSky,
        );
        expect(s1.secondaryPalette.hue != s2.secondaryPalette.hue, true);
      });
    });
  });
}
