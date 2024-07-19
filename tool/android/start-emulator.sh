#!/usr/bin/env bash

# Arguments:
#   $1 AVD_NAME like Pixel_Fold_API_35 or Nexus_7_API_35
#   $2 SYSTEM_IMAGE_PACKAGE_PATH like "system-images;android-35;google_apis;x86_64"
#   $3 DEVICE_NAME like pixel_fold or Nexus 7 2013
#   $4 SKIN_NAME like pixel_fold or nexus_7_2013

set -e -o pipefail

# ./tool/android/start-emulator-actions-prerequisite.sh

if [[ $(uname -m) == "arm64" ]]; then
  SYSTEM_IMAGE_ARCH="arm64-v8a"
else
  SYSTEM_IMAGE_ARCH="x86_64"
fi

AVD_NAME=${1:-"Pixel_Fold_API_35"}
SYSTEM_IMAGE_PACKAGE_PATH=${2:-"system-images;android-35;google_apis;$SYSTEM_IMAGE_ARCH"}
DEVICE_NAME=${3:-"pixel_fold"}
SKIN_NAME=${4:-"pixel_fold"}

if [[ $(uname -s) =~ ^"MINGW" ]]; then
  SdkManager="sdkmanager.bat"
  AvdManager="avdmanager.bat"
else
  SdkManager="sdkmanager"
  AvdManager="avdmanager"
fi

AVD_PID=$(./tool/android/avd-already-running.sh "$AVD_NAME")
if [[ -z $AVD_PID ]]; then
  AVD_ALREADY_RUNNING=false
  if ! ls "$HOME/.android/avd/${AVD_NAME}.ini"; then
    if [[ ! -d "$ANDROID_HOME/${SYSTEM_IMAGE_PACKAGE_PATH//;//}" ]]; then
      $SdkManager --install "$SYSTEM_IMAGE_PACKAGE_PATH"
    fi
    $AvdManager create avd --name "$AVD_NAME" \
      --package "$SYSTEM_IMAGE_PACKAGE_PATH" \
      --device "$DEVICE_NAME" \
      --skin "$SKIN_NAME"
  fi
  emulator "@$AVD_NAME" &
else
  AVD_ALREADY_RUNNING=true
fi

echo "AVD_ALREADY_RUNNING=$AVD_ALREADY_RUNNING"

# shellcheck disable=SC2016
adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed) ]]; do sleep 1; done;'
