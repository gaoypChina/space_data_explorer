#!/usr/bin/env bash

# Arguments:
#   $1 FLAVOR_ENV dev / stag / prod.

set -e -o pipefail

if [[ $LOGS_ENV_SOURCED != "true" ]]; then
  source ./tool/shell/logs-env.sh
fi

FLAVOR_ENV=${1:?\
$(print_in_red "Missing argument \$1 FLAVOR_ENV dev / stag / prod.")}

pushd "ios/fastlane/$FLAVOR_ENV/screenshots/en-US" &> /dev/null

# 5.5" iPhone SE (3rd generation) resized to iPhone 8 Plus screenshots
magick mogrify -resize 1242x2208! "*_APP_IPHONE_55_*.png"

# 12.9" iPad Pro 11-inch (M4) resized to iPad Pro (12.9-inch) (2nd generation)
magick mogrify -resize 2048x2732! "*_APP_IPAD_PRO_129_*.png"

popd &> /dev/null
