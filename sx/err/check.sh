#!/bin/bash

# sx_chekc is used when you want to make sure that previous command exited without any failures

sx_check() {
  local code=$1
  local msg=$2

  # shellcheck disable=SC2086
  if [ $code -ne 0 ]; then
    if [ -n "$msg" ]; then
      echo "$msg" >&2
    fi

    exit 1
  fi
}
