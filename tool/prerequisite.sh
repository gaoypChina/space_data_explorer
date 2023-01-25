#!/usr/bin/env bash

set -e

source ./tool/constants.sh
source ./tool/set-logs-env.sh

check_on_path() {
  if [[ ! -x $(command -v "$1") ]]; then
    error_log_with_exit "$1 not found on PATH" 1
  fi
}

if [[ $(uname -s) =~ ^"Darwin" ]]; then
  check_on_path brew
elif [[ $(uname -s) =~ ^"MINGW" ]]; then
  check_on_path choco
  if [[ ! $GITHUB_ACTIONS ]]; then
    check_on_path winget
  fi
fi

check_on_path java
JAVA_CLASS_MAJOR_VERSION=$( \
  javap -verbose java.lang.String \
    | grep "major version" \
    | cut -d " " -f 5 \
)
: "${JAVA_CLASS_MAJOR_VERSION:=-1}"
if (( "$JAVA_CLASS_MAJOR_VERSION" < 55 )); then
  error_log "JDK 11 not found on PATH"
  JAVA_VERSION_OUTPUT="$(java --version)"
  print_in_red "$JAVA_VERSION_OUTPUT"
  exit 1
fi

check_on_path pip
PIP_INSTALL_OUTPUT=$(pip install -r requirements.txt)
if [[ $CI ]]; then
  echo "$PIP_INSTALL_OUTPUT"
elif [[ ! $PIP_INSTALL_OUTPUT =~ "Requirement already satisfied" ]]; then
  echo "$PIP_INSTALL_OUTPUT"
fi
[[ -x $(command -v csv2md) ]] \
  || error_log_with_exit "pip installed packages not found on PATH" 1

if [[ ! -x $(command -v lcov) ]]; then
  if [[ $(uname -s) =~ ^"Linux" ]]; then
    sudo apt install lcov
  elif [[ $(uname -s) =~ ^"Darwin" ]]; then
    brew install lcov
  elif [[ $(uname -s) =~ ^"MINGW" ]]; then
    choco install lcov
    if [[ $GITHUB_ACTIONS ]]; then
      # shellcheck disable=SC2028
      echo "C:\ProgramData\chocolatey\lib\lcov\tools\bin" >> "$GITHUB_PATH"
    else
      export PATH="/c/ProgramData/chocolatey/lib/lcov/tools/bin:$PATH"
    fi
  fi
  lcov --version
fi

if [[ $(uname -s) =~ ^"Darwin" ]]; then
  brew install diffutils
  diff --version
fi

if [[ ! -x $(command -v jq) ]]; then
  if [[ $(uname -s) =~ ^"Linux" ]]; then
    sudo apt install jq
  elif [[ $(uname -s) =~ ^"Darwin" ]]; then
    brew install jq
  elif [[ $(uname -s) =~ ^"MINGW" ]]; then
    if [[ $GITHUB_ACTIONS ]]; then
      choco install jq
    else
      winget install jq
    fi
  fi
  jq --version
fi

if [[ ! -x $(command -v yq) ]]; then
  if [[ $(uname -s) =~ ^"Linux" ]]; then
    sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 \
      -O /usr/bin/yq
    sudo chmod +x /usr/bin/yq
  elif [[ $(uname -s) =~ ^"Darwin" ]]; then
    brew install yq
  elif [[ $(uname -s) =~ ^"MINGW" ]]; then
    if [[ $GITHUB_ACTIONS ]]; then
      choco install yq
    else
      winget install yq
    fi
  fi
  yq --version
fi

if [[ ! $CI ]]; then
  if [[ ! -s $BUNDLETOOL_PATH ]]; then
    ./tool/android/install-bundletool.sh
  fi
fi
