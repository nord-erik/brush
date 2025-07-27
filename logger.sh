#!/bin/bash

# this script contains logging utilities that can be used by anyone really
# functions prefixed "__" are not meant to be used directly, but who can stop you

__bru_system_logger() {
  local prio=$1
  local suffix=$2
  local msg=$3

  logger -t "$BRU_APP_NAME" -p "user.$prio" "[$$] $suffix $msg"
}

__bru_terminal_print() {
  local colour=$1
  local suffix=$2
  local msg=$3

  # printf more stable than echo
  printf "%b %s\n" "$colour$suffix$BRU_CLEAR" "$msg"
}

# prints a visual error and logs it
bru_error() {
  local msg=$1

  __bru_system_logger "err" "(ERROR)" "$msg"
  __bru_terminal_print "$BRU_RED" "error:" "$msg"
}

# prints a visual warning and logs it
bru_warning() {
  local msg=$1

  __bru_system_logger "warn" "(WARNING)" "$msg"
  __bru_terminal_print "$BRU_YELLOW" "warning:" "$msg"
}

# prints a visual notice and logs it
bru_notice() {
  local msg=$1

  __bru_system_logger "notice" "(NOTICE)" "$msg"
  __bru_terminal_print "$BRU_BLUE" "notice:" "$msg"
}

# prints a visual message and logs it
bru_log() {
  local msg=$1

  __bru_system_logger "info" "(INFO)" "$msg"
  __bru_terminal_print "$BRU_WHITE" "info:" "$msg"
}
