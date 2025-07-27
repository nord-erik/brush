#!/bin/bash

# sweep_root checks if the user is root, for when that is required

sweep_root() {
  local current_uid
  current_uid="$(id -u)"

  if [ "$current_uid" -eq 0 ]; then
    return 0
  else
    sweep_ok 1 "you must be root to run, please sudo"
  fi
}
