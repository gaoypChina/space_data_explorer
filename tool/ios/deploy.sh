#!/usr/bin/env bash

# Arguments:
#   $1 FLAVOR_ENV dev / stag / prod.

set -e -o pipefail

if [[ $LOGS_ENV_SOURCED != "true" ]]; then
  source ./tool/shell/logs-env.sh
fi

FLAVOR_ENV=${1:?\
$(print_in_red "Missing argument \$1 FLAVOR_ENV dev / stag / prod.")}

source ./tool/constants.sh

if [[ $FLAVOR_ENV == "prod" ]]; then
  ./tool/ios/upload-all.sh "$FLAVOR_ENV"
else
  ./tool/ios/upload-metadata-screenshots.sh "$FLAVOR_ENV"
  ./tool/ios/upload-ipa.sh "$FLAVOR_ENV"
fi

# shellcheck disable=SC1091
source ./build/ios/build-phases-variables.env

# Keep this in sync with Build Phase script of 'FlutterFire: "flutterfire upload-crashlytics-symbols"'
dart pub global run flutterfire_cli:flutterfire upload-crashlytics-symbols \
  --upload-symbols-script-path "$PODS_ROOT/FirebaseCrashlytics/upload-symbols" \
  --platform ios \
  --apple-project-path "$SRCROOT" \
  --env-platform-name "$PLATFORM_NAME" \
  --env-configuration "$CONFIGURATION" \
  --env-project-dir "$PROJECT_DIR" \
  --env-built-products-dir "$BUILT_PRODUCTS_DIR" \
  --env-dwarf-dsym-folder-path "$DWARF_DSYM_FOLDER_PATH" \
  --env-dwarf-dsym-file-name "$DWARF_DSYM_FILE_NAME" \
  --env-infoplist-path "$INFOPLIST_PATH" \
  --build-configuration "$CONFIGURATION"

# shellcheck disable=SC1091
source ./secrets/sentry/source.sh
sentry-cli debug-files upload \
  --include-sources \
  "$DWARF_DSYM_FOLDER_PATH/$DWARF_DSYM_FILE_NAME"
