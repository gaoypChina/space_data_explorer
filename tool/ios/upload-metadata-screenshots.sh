#!/usr/bin/env bash

# Arguments:
#   $1 FLAVOR_ENV dev / stag / prod.

set -e -o pipefail

FLAVOR_ENV=${1:?"Missing argument \$1 FLAVOR_ENV dev / stag / prod."}

source ./tool/constants.sh

API_KEY_PATH_ARG=()
if [[ -s ./secrets/.git ]]; then
  if [[ $GITHUB_ACTIONS == "true" ]]; then
    API_KEY_PATH_ARG=(api_key_path:"../secrets/ios/app-store-connect/non-interactive.json")
  else
    API_KEY_PATH_ARG=(api_key_path:"../secrets/ios/app-store-connect/interactive.json")
  fi
fi

APP_IDENTIFIER="$(./tool/ios/get-app-identifier.sh "$FLAVOR_ENV")"

pushd ios &> /dev/null

bundle exec fastlane run upload_to_app_store \
  "${API_KEY_PATH_ARG[@]}" \
  app_identifier:"$APP_IDENTIFIER" \
  app_version:"$VERSION_MAJOR_MINOR_PATCH" \
  metadata_path:"./fastlane/$FLAVOR_ENV/metadata" \
  screenshots_path:"./fastlane/$FLAVOR_ENV/screenshots" \
  overwrite_screenshots:true \
  automatic_release:true \
  run_precheck_before_submit:false \
  force:true

popd &> /dev/null
