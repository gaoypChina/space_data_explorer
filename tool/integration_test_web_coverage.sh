#!/usr/bin/env bash

set -e

TARGET_PATHS=(
  "integration_test/platform_specific_app_bar_test.dart"
)
if [[ $CI ]] ; then
  DEVICE="web-server"
else
  DEVICE="chrome"
fi
for TARGET_PATH in "${TARGET_PATHS[@]}"; do
  (
    flutter run "$TARGET_PATH" \
      --vmservice-out-file=coverage/vm-service-url.txt \
      -d $DEVICE &
    sleep 35
    dart pub global run coverage:collect_coverage \
      --uri="$(cat coverage/vm-service-url.txt)" \
      --out coverage/coverage.json
  )
done
