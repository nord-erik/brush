#!/bin/bash

# sweep_ok is used when you want to make sure that previous command exited without any failure
# you just pass $? and a message, sweep_ok manage the rest.

sweep_ok() {
  local code=$1
  local msg=$2
  local custom_error_code=$3

  if [ -z "$custom_error_code" ]; then
    custom_error_code=1
  fi

  # shellcheck disable=SC2086
  if [ $code -ne 0 ]; then
    if [ -n "$msg" ]; then
      brush_error "$msg"
    fi

    exit $custom_error_code
  fi
}
