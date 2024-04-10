import 'package:flutter_test/flutter_test.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:integration_test/integration_test.dart';
import 'package:web/web.dart' as web;

import '../globals.dart';

void historyBack() {
  web.window.history.back();
}

void historyForward() {
  web.window.history.forward();
}

void resetNavigationHistoryState() {
  final web.History history = web.window.history;
  Map? state = history.state as Map?;
  if (state != null) {
    // Not working
    // history.go(-(history.length - 1));
    for (int i = history.length; i >= 1; i--) {
      history.back();
    }
  }
  // history.replaceState(null, '', null);
}

void logNavigationHistoryState() {
  final web.History history = web.window.history;
  printLogger.debug('history.length = ${history.length}');
  Map? state = history.state as Map?;
  printLogger.debug('history.state = $state');
}

bool expectHistoryLengthAndSerialCount(
  int historyLength,
  int serialCount,
) {
  final web.History history = web.window.history;
  Map state = history.state as Map;

  testLogger.finer('history.length = ${history.length}');
  testLogger.finer('state[\'serialCount\'] = ${state['serialCount']}');
  testLogger.finer('historyLength = $historyLength');
  testLogger.finer('serialCount = $serialCount');

  // TODO(hrishikesh-kadam): Fails after `All tests passed!`
  // expect(history.length, historyLength);
  // expect(state['serialCount'], serialCount);

  bool historyLengthNotEqual = false;
  bool serialCountNotEqual = false;
  if (historyLengthNotEqual = history.length != historyLength) {
    printLogger.error('history.length != historyLength');
    printLogger.error('${history.length} != $historyLength');
  }
  if (serialCountNotEqual = state['serialCount'] != serialCount) {
    printLogger.error('state[\'serialCount\'] != serialCount');
    printLogger.error('${state['serialCount']} != $serialCount');
  }
  if (historyLengthNotEqual || serialCountNotEqual) {
    return false;
  } else {
    return true;
  }
}

Future<void> testScreenshot(
  String name,
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
) async {
  await tester.pumpAndSettle();
  await binding.takeScreenshot(name);
}
