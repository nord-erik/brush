#!/bin/bash

# sweep_root checks if the user is root, for when that is required

sweep_root() {
  local current_uid final_app_name
  current_uid="$(id -u)"

  if [ "$current_uid" -eq 0 ]; then
    return 0
  fi

  if [ "$BRUSH_APP_NAME" = "$BRUSH_DEFAULT_APP_NAME" ]; then
    final_app_name="this script"
  else
    final_app_name="'$BRUSH_APP_NAME'"
  fi

  brush_error "you must be root in order to run $final_app_name, please re-run with sudo"
  exit 1
}
