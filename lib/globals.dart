import 'package:flutter/foundation.dart';

import 'package:logging/logging.dart';

import 'constants.dart';
import 'utility/utility.dart';

final log = Logger(appNameKebabCase);

const isNormalLink = 'isNormalLink';

/// isNormalLink is used to check if the page was opened by normal-link or deep-link.
Map getExtra() {
  final Map extra = {};
  extra[isNormalLink] = true;
  return extra;
}

bool flutterTest = isFlutterTest();

@visibleForTesting
bool isSurfaceRendered = false;
