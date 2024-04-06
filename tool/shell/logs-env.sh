#!/usr/bin/env bash

# shellcheck disable=SC1090
source <(curl -s https://raw.githubusercontent.com/hrishikesh-kadam/common-scripts/main/logs/logs-env-posix.sh)

if [ -z ${-%*e*} ]; then PARENT_ERREXIT=true; else PARENT_ERREXIT=false; fi
if shopt -qo pipefail; then PARENT_PIPEFAIL=true; else PARENT_PIPEFAIL=false; fi

set -e -o pipefail

export -f print_in_red
export -f print_in_yellow
export -f print_in_green
export -f print_in_cyan
export -f log_error
export -f log_warning
export -f log_info
export -f log_debug
export -f log_error_with_exit
export -f log_error_with_help

export LOGS_ENV_SOURCED="true"

if [ $PARENT_ERREXIT = "true" ]; then set -e; else set +e; fi
if [ $PARENT_PIPEFAIL = "true" ]; then set -o pipefail; else set +o pipefail; fi
