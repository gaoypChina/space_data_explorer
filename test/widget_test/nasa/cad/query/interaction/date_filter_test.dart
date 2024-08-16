// ignore_for_file: directives_ordering

import 'package:flutter/material.dart';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hrk_flutter_test_batteries/hrk_flutter_test_batteries.dart';

import 'package:space_data_explorer/nasa/cad/bloc/cad_bloc.dart';
import 'package:space_data_explorer/nasa/cad/cad_route.dart';
import 'package:space_data_explorer/nasa/cad/cad_screen.dart';
import 'package:space_data_explorer/route/settings/date_format_pattern.dart';
import 'package:space_data_explorer/widgets/date_filter_widget.dart';
import '../../../../../src/extension/custom_checks.dart';
import '../../../../../src/globals.dart';
import '../../../../../src/nasa/cad/cad_route.dart';
import '../../../../../src/nasa/cad/query/date_filter.dart';
import '../../../../../src/route/settings/settings_route.dart';
import '../../../../../src/route/settings/tiles/date_format_tile.dart';

void main() {
  group('$CadRoute $DateFilterWidget Interaction Test', () {
    testWidgets('DeferredLoading workaround', (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      await tapSearchButton(tester);
      await tapSettingsAction(tester);
    });

    testWidgets('No interation', (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      expectDate(tester, minDateTextDefault, minDateFinder);
      expectDate(tester, maxDateTextDefault, maxDateFinder);
    });

    testWidgets('Tap ${l10n.selectDateRange}, select dates, tap Save',
        (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      await selectDateRange(tester);
      expectDatePattern(tester, minDateForTest.day.toString(), minDateFinder);
      expectDatePattern(tester, maxDateForTest.day.toString(), maxDateFinder);
    });

    testWidgets('Tap ${l10n.selectDateRange}, tap $CloseButton',
        (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      await tester.tap(selectDateRangeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expectDate(tester, minDateTextDefault, minDateFinder);
      expectDate(tester, maxDateTextDefault, maxDateFinder);
    });

    testWidgets(
        'Tap ${l10n.selectDateRange}, select dates, tap Save, '
        'tap ${l10n.selectDateRange}, tap $CloseButton',
        (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      await selectDateRange(tester);
      await tester.tap(selectDateRangeButtonFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(CloseButton));
      await tester.pumpAndSettle();
      expectDate(tester, minDateTextDefault, minDateFinder);
      expectDate(tester, maxDateTextDefault, maxDateFinder);
    });

    testWidgets('Reacts to $DateFormatPattern settings change',
        (WidgetTester tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      await selectDateRange(tester);
      String minDateBeforeString = tester.widget<Text>(minDateFinder).data!;
      String maxDateBeforeString = tester.widget<Text>(maxDateFinder).data!;
      await tapSettingsAction(tester);
      await tapDateFormatTile(tester);
      await chooseDateFormat(tester,
          l10n: l10n, dateFormatPattern: DateFormatPattern.ddMMyyyySlash);
      await tapBackButton(tester);
      String minDateAfterString = tester.widget<Text>(minDateFinder).data!;
      String maxDateAfterString = tester.widget<Text>(maxDateFinder).data!;
      check(minDateAfterString).notEquals(minDateTextDefault);
      check(maxDateAfterString).notEquals(maxDateTextDefault);
      check(minDateBeforeString).notEquals(minDateAfterString);
      check(maxDateBeforeString).notEquals(maxDateAfterString);
    });

    testWidgets('disableInputs', (tester) async {
      await pumpCadRouteAsInitialLocation(tester);
      expect(selectDateRangeButtonFinder.hitTestable().evaluate().length, 1);
      await emitDisableInputs(tester);
      expect(selectDateRangeButtonFinder.hitTestable().evaluate().length, 0);
    });

    testWidgets('CadBloc prefilled, reset', (tester) async {
      final cadBloc = getCadBloc();
      cadBloc.add(CadDateRangeSelected(dateRange: dateRangeForTest));
      await pumpCadRouteAsInitialLocation(tester, cadBloc: cadBloc);
      expectDatePattern(tester, minDateForTest.day.toString(), minDateFinder);
      expectDatePattern(tester, maxDateForTest.day.toString(), maxDateFinder);
      cadBloc.add(const CadDateRangeSelected(dateRange: null));
      await tester.pumpAndSettle();
      expectDate(tester, minDateTextDefault, minDateFinder);
      expectDate(tester, maxDateTextDefault, maxDateFinder);
    });

    testWidgets('verifyQueryParameters()', (tester) async {
      final List<DateTimeRange> dateRangeList = [
        DateTimeRange(start: minDateDefault, end: maxDateDefault),
        DateTimeRange(
          start: minDateDefault.subtract(const Duration(days: 1)),
          end: maxDateDefault,
        ),
        DateTimeRange(
          start: minDateDefault.add(const Duration(days: 1)),
          end: maxDateDefault,
        ),
        DateTimeRange(
          start: minDateDefault,
          end: maxDateDefault.subtract(const Duration(days: 1)),
        ),
        DateTimeRange(
          start: minDateDefault,
          end: maxDateDefault.add(const Duration(days: 1)),
        ),
        DateTimeRange(
          start: minDateDefault.subtract(const Duration(days: 1)),
          end: maxDateDefault.subtract(const Duration(days: 1)),
        ),
        DateTimeRange(
          start: minDateDefault.add(const Duration(days: 1)),
          end: maxDateDefault.add(const Duration(days: 1)),
        ),
      ];
      await pumpCadRouteAsInitialLocation(tester);
      for (final dateRange in dateRangeList) {
        CadScreen.cadBloc!.add(CadDateRangeSelected(dateRange: dateRange));
        await tester.pumpAndSettle();
        await verifyDateRangeQueryParameters(tester, dateRange);
      }
    });
  });
}
