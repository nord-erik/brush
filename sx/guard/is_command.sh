#!/bin/bash

sx_is_command() {
  local cmd=$1

  command -v "$cmd" > /dev/null 2>&1
  sx_check $? "required command '$cmd' not found"
}
