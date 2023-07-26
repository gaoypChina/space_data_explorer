import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrk_flutter_test_batteries/hrk_flutter_test_batteries.dart';

import 'package:space_data_explorer/route/home/home_screen.dart';
import 'package:space_data_explorer/route/settings/bloc/settings_bloc.dart';
import 'package:space_data_explorer/route/settings/language.dart';
import 'package:space_data_explorer/route/settings/settings_screen.dart';
import '../../../../src/config/hydrated_bloc.dart';
import '../../../../src/globals.dart';
import '../../../../src/route/settings/settings_route.dart';

final languageTileFinder = find.byKey(SettingsScreen.languageTileKey);
final languageDialogFinder = find.byKey(SettingsScreen.languageDialogKey);

void main() {
  group('$SettingsScreen ${l10n.language} Tile Widget Test', () {
    testWidgets('Basic', (tester) async {
      await pumpSettingsRouteAsNormalLink(tester);
      expect(languageTileFinder, findsOneWidget);
      final settingsBloc = navigatorKey.currentContext!.read<SettingsBloc>();
      expect(settingsBloc.state.language, Language.system);
    });

    testWidgets('Choose ${Language.english}', (tester) async {
      const language = Language.english;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
    });

    testWidgets('Choose ${Language.hindi}', (tester) async {
      const language = Language.hindi;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
    });

    testWidgets('Choose ${Language.marathi}', (tester) async {
      const language = Language.marathi;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
    });

    testWidgets('Choose ${Language.system}', (tester) async {
      const language = Language.system;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
    });

    testWidgets('System Locale Changed', (tester) async {
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      final platformLocales = tester.platformDispatcher.locales;
      final changedPlatformLocales = List.of(platformLocales, growable: true);
      changedPlatformLocales.add(Locale(Language.hindi.code));
      tester.platformDispatcher.localesTestValue = changedPlatformLocales;
      await tester.pumpAndSettle();
      expect(languageDialogFinder, findsNothing);
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Tap and dismiss without choosing any value', (tester) async {
      await pumpSettingsRouteAsNormalLink(tester);
      final settingsBloc = navigatorKey.currentContext!.read<SettingsBloc>();
      expect(settingsBloc.state.isAnyDialogShown, null);
      await tapLanguageTile(tester);
      expect(settingsBloc.state.isAnyDialogShown, true);
      await tester.tap(find.byType(AppBar), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(languageDialogFinder, findsNothing);
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(settingsBloc.state.isAnyDialogShown, false);
    });

    testWidgets('Choose ${Language.english}, exit screen, enter again',
        (tester) async {
      const language = Language.english;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
      await tapBackButton(tester);
      await tapSettingsButton(tester);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
    });

    testWidgets(
        'With Hydration, Choose ${Language.english}, exit app, enter again',
        (tester) async {
      final storageDirectory = Directory(
        'build/test/widget_test/route/settings/tiles/storage',
      );
      // Stucks in setUpHydratedBloc()
      await setUpHydratedBloc(storageDirectory);
      const language = Language.english;
      await pumpSettingsRouteAsNormalLink(tester);
      await tapLanguageTile(tester);
      await chooseLanguage(tester, l10n: l10n, language: language);
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
      await tapBackButton(tester);
      await simulateAndroidBackButton(tester);
      expect(find.byType(HomeScreen), findsOneWidget);
      runApp(Container(key: UniqueKey()));
      await tester.pump();
      await pumpSettingsRouteAsNormalLink(tester, navigatorKey: GlobalKey());
      await verifyLanguageTileSubtitle(tester, l10n: l10n, language: language);
      await tearDownHydratedBloc(storageDirectory);
    }, skip: true);
  });
}

// TODO(hrishikesh-kadam): Move this to source
Future<void> tapLanguageTile(WidgetTester tester) async {
  await tester.tap(languageTileFinder);
  await tester.pumpAndSettle();
  // TODO(hrishikesh-kadam): Move this expect
  expect(languageDialogFinder, findsOneWidget);
}

// TODO(hrishikesh-kadam): Move this to source
Future<void> chooseLanguage(
  WidgetTester tester, {
  required AppLocalizations l10n,
  required Language language,
}) async {
  await tester.tap(find.byKey(Key(SettingsScreen.getLanguageValueTitle(
    l10n: l10n,
    language: language,
  ))));
  await tester.pumpAndSettle();
  // TODO(hrishikesh-kadam): Move this expect
  expect(languageDialogFinder, findsNothing);
}

// TODO(hrishikesh-kadam): Move this to source
Future<void> verifyLanguageTileSubtitle(
  WidgetTester tester, {
  required AppLocalizations l10n,
  required Language language,
}) async {
  final subTitleFinder = find.descendant(
    of: languageTileFinder,
    matching: find.text(
      SettingsScreen.getLanguageValueTitle(
        l10n: l10n,
        language: language,
      ),
    ),
  );
  // TODO(hrishikesh-kadam): Move this expect
  expect(subTitleFinder, findsOneWidget);
}
