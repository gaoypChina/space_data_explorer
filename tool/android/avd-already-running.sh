#!/usr/bin/env bash

# $1 AVD_NAME like Pixel_Fold_API_35

set -e -o pipefail

AVD_NAME=${1:-"Pixel_Fold_API_35"}

if [[ $(uname -s) =~ ^"MINGW" ]]; then
  output=$(tasklist \
    //fi "STATUS eq running" \
    //fi "WINDOWTITLE eq Android Emulator - $AVD_NAME*" \
    //fo list)
  if [[ $output =~ "No tasks are running" ]]; then
    exit 0
  fi
  output_lines=$(echo "$output" | grep --count PID)
else
  if [[ $(uname -s) =~ ^"Darwin" ]]; then
    PGREP_OPTIONS=("-fl")
  else
    PGREP_OPTIONS=("--list-full" "--full")
  fi
  output=$(pgrep "${PGREP_OPTIONS[@]}" "emulator/qemu.*$AVD_NAME") || true
  if [[ -z $output ]]; then
    exit 0
  fi
  output_lines=$(echo "$output" | wc -l)
fi

if (( output_lines > 1 )); then
  error="Multiple instances of the $AVD_NAME are running"
  printf "%b%s%b\n" "\033[31m" "$error" "\033[0m" >&2
  exit 1
fi

if [[ $(uname -s) =~ ^"MINGW" ]]; then
  AVD_PID=$(echo "$output" | grep PID | awk 'NR == 1 { print $2 }')
else
  AVD_PID=$(echo "$output" | awk 'NR == 1 { print $1 }')
fi

echo "$AVD_PID"
