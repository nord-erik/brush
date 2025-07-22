#!/bin/bash

# sx_chekc is used when you want to make sure that previous command exited without any failures

sx_check() {
  local code=$1

  if [ $code -ne 0 ]; then
    echo "error">&2
    exit 1
  fi

  exit 0
}
