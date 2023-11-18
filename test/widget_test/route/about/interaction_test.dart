import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:space_data_explorer/route/about/about_route.dart';
import '../../../src/route/about/about_route.dart';

void main() {
  group('$AboutRoute Interaction Test', () {
    testWidgets('Tap all links', (tester) async {
      await pumpAboutRouteAsInitialLocation(tester);
      await tapLinktreeUri(tester);
      await tapSourceUri(tester);
      await tapWebAppUri(tester);
    });

    // TODO(hrishikesh-kadam): not hit test on the specified widget
    testWidgets('Tap all links, iOS', (tester) async {
      await pumpAboutRouteAsInitialLocation(tester);
      await tapGooglePlayBadge(tester);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS), skip: true);
  });
}
