#!/bin/bash

# this script contains logging utilities that can be used by anyone really
# functions prefixed "__" are not meant to be used directly, but who can stop you

__sx_log() {
  local prio=$1
  local suffix=$2
  local msg=$3

  logger -t "$SX_APP_NAME" -p "user.$prio" "[$$] $suffix $msg"
}

__sx_echo() {
  local colour=$1
  local suffix=$2
  local msg=$3

  # printf more stable than echo
  printf "%b %s\n" "$colour$suffix$SXC_CLEAR" "$msg"
}

# prints a visual error and logs it
sx_error() {
  local msg=$1

  __sx_log "err" "(ERROR)" "$msg"
  __sx_echo "$SXC_RED" "error:" "$msg"
}

# prints a visual warning and logs it
sx_warn() {
  local msg=$1

  __sx_log "warn" "(WARNING)" "$msg"
  __sx_echo "$SXC_YELLOW" "warning:" "$msg"
}

# prints a visual notice and logs it
sx_notice() {
  local msg=$1

  __sx_log "notice" "(NOTICE)" "$msg"
  __sx_echo "$SXC_BLUE" "notice:" "$msg"
}

# prints a visual message and logs it
sx_log() {
  local msg=$1

  __sx_log "info" "(INFO)" "$msg"
  __sx_echo "$SXC_WHITE" "info:" "$msg"
}
