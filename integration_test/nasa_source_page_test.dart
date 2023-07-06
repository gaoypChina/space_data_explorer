import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:space_data_explorer/nasa/nasa_page.dart';
import 'package:space_data_explorer/nasa/nasa_screen.dart';
import 'package:space_data_explorer/pages/home_page.dart';
import 'package:space_data_explorer/space_data_explorer.dart';
import 'home_page_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('$NasaPage Integration Test', (WidgetTester tester) async {
    await pumpNasaSourcePageAsNormalLink(tester);
  });
}

Future<void> pumpNasaSourcePageAsInitialLocation(WidgetTester tester) async {
  await tester.pumpWidget(SpaceDataExplorerApp(
    initialLocation: NasaPage.path,
  ));
  await tester.pumpAndSettle();
  expect(find.byType(NasaScreen), findsOneWidget);
}

Future<void> pumpNasaSourcePageAsNormalLink(WidgetTester tester) async {
  await pumpHomePage(tester);
  final nasaSourceTextButton =
      find.widgetWithText(TextButton, NasaPage.pageName);
  await tester.tap(nasaSourceTextButton);
  await tester.pumpAndSettle();
  expect(find.byType(HomeScreen, skipOffstage: false), findsOneWidget);
  expect(find.byType(NasaScreen), findsOneWidget);
}
