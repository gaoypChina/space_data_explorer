#!/usr/bin/env bash

set -e -o pipefail

./tool/web/deploy.sh

if [[ $GITHUB_EVENT_NAME != "pull_request" ]]; then
  ./tool/android/publish.sh
fi

git status -s
