#!/usr/bin/env bash

set -e -o pipefail

flutter clean
# https://stackoverflow.com/a/75659829/3302026
rm -rf .crashlytics
