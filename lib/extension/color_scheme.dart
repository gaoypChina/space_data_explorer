import 'package:flutter/material.dart';

import 'package:material_color_utilities/material_color_utilities.dart';

// LABEL: eligible-hrk_flutter_batteries
extension ColorSchemeExt on ColorScheme {
  // For surface which contains brightness unaware contents like brand images
  Color get surfaceFixed {
    final Hct surfaceHct = Hct.fromInt(surface.value);
    final Hct surfaceFixedHct = Hct.from(
      surfaceHct.hue,
      surfaceHct.chroma,
      80,
    );
    return Color(surfaceFixedHct.toInt());
  }
}
