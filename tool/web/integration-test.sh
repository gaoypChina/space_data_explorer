#!/usr/bin/env bash

# Arguments:
#   $1 FLAVOR_ENV dev / stag / prod.

set -e -o pipefail

if [[ $LOGS_ENV_SOURCED != "true" ]]; then
  source ./tool/shell/logs-env.sh
fi

FLAVOR_ENV=${1:?\
$(print_in_red "Missing argument \$1 FLAVOR_ENV dev / stag / prod.")}

chromedriver --port=4444 &
TARGET_PATHS=(
  "integration_test/app_bar_back_button_test.dart"
)
if [[ $GITHUB_ACTIONS == "true" ]] ; then
  DEVICE="web-server"
else
  DEVICE="chrome"
fi
# TODO(hrishikesh-kadam): Keep checking this for stable updates
# The `flutter drive` command needs `--web-renderer html` because: 
# 1. Default web renderer is moving to canvaskit.  
#    This change is after 3.22 announcement.
# 2. Fix for flutter drive command with web renderer canvaskit is in 
#    master channel but not in stable (3.24) at this time.  
#    Couldn't know which commit in flutter/flutter resolves the issue.
# References:
# - https://github.com/flutter/flutter/issues/149826
# - https://github.com/flutter/packages/pull/7115#issuecomment-2229569641
# - https://github.com/flutter/packages/pull/7146
# - https://github.com/flutter/flutter/issues/151869
for TARGET_PATH in "${TARGET_PATHS[@]}"; do
  flutter drive \
    --dart-define="FLAVOR_ENV=$FLAVOR_ENV" \
    --dart-define="FLUTTER_TEST=true" \
    --driver test_driver/integration_test.dart \
    --target "$TARGET_PATH" \
    --web-renderer html \
    -d $DEVICE
done
