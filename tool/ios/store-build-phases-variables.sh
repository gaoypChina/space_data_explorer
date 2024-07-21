#!/usr/bin/env bash

set -e -o pipefail

# Variables used in Build Phase script of 'FlutterFire: "flutterfire upload-crashlytics-symbols"'
OUTPUT_FILE="../build/ios/build-phases-variables.env"
{
  echo "# shellcheck shell=sh"
  echo "export PODS_ROOT=\"$PODS_ROOT\""
  echo "export SRCROOT=\"$SRCROOT\""
  echo "export PLATFORM_NAME=\"$PLATFORM_NAME\""
  echo "export CONFIGURATION=\"$CONFIGURATION\""
  echo "export PROJECT_DIR=\"$PROJECT_DIR\""
  echo "export BUILT_PRODUCTS_DIR=\"$BUILT_PRODUCTS_DIR\""
  echo "export DWARF_DSYM_FOLDER_PATH=\"$DWARF_DSYM_FOLDER_PATH\""
  echo "export DWARF_DSYM_FILE_NAME=\"$DWARF_DSYM_FILE_NAME\""
  echo "export INFOPLIST_PATH=\"$INFOPLIST_PATH\""
} > $OUTPUT_FILE
