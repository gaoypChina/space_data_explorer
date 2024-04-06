#!/usr/bin/env bash

set -e -o pipefail

if [[ $LOGS_ENV_SOURCED != "true" ]]; then
  source ./tool/shell/logs-env.sh
fi

set -x

dart format --output none --set-exit-if-changed .

dart run import_sorter:main --exit-if-changed

# TODO(hrishikesh-kadam): Required after 3.22.0-0.1.pre
# Keep checking if really needed
flutter pub get

flutter analyze
