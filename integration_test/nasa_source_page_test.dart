import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:space_data_explorer/pages/home_page.dart';
import 'package:space_data_explorer/pages/nasa_source/nasa_source_page.dart';
import 'package:space_data_explorer/pages/nasa_source/nasa_source_screen.dart';
import 'home_page_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('NasaSourcePage Integration Test', (WidgetTester tester) async {
    await nasaSourcePageIntegrationTest(tester);
  });
}

Future<void> nasaSourcePageIntegrationTest(WidgetTester tester) async {
  await homePageIntegrationTest(tester);
  final nasaSourceTextButton =
      find.widgetWithText(TextButton, NasaSourcePage.pageName);
  await tester.tap(nasaSourceTextButton);
  await tester.pumpAndSettle();
  expect(find.byType(HomeScreen, skipOffstage: false), findsOneWidget);
  expect(find.byType(NasaSourceScreen), findsOneWidget);
}
